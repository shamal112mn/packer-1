package com.lib
import groovy.json.JsonSlurper

def runPipeline() {

  def k8slabel = "jenkins-pipeline-${UUID.randomUUID().toString()}"

  // // Getting common functions from jenkins global library
  def commonFunctions        = new CommonFunction()

  // // Get username who run the job 
  def triggerUser            = commonFunctions.getBuildUser()

  def slavePodTemplate = """
      metadata:
        labels:
          k8s-label: ${k8slabel}
        annotations:
          jenkinsjoblabel: ${env.JOB_NAME}-${env.BUILD_NUMBER}
      spec:
        affinity:
          podAntiAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                - key: component
                  operator: In
                  values:
                  - jenkins-jenkins-master
              topologyKey: "kubernetes.io/hostname"
        containers:
        - name: python-container
          image: python:latest
          imagePullPolicy: IfNotPresent
          command:
          - cat
          tty: true
          volumeMounts:
            - mountPath: /var/run/docker.sock
              name: docker-sock
            - mountPath: /etc/secrets/service-account/
              name: google-service-account
        serviceAccountName: common-service-account
        securityContext:
          runAsUser: 0
          fsGroup: 0
        volumes:
          - name: google-service-account
            secret:
              secretName: google-service-account
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock
  """
  properties([
    parameters([
      gitParameter(
        branch: '', branchFilter: 'origin/(.*)', defaultValue: "${GIT_BRANCH}", 
        description: 'Please select the branch you would like to build ', 
        name: 'GIT_BRANCH', quickFilterEnabled: true, 
        selectedValue: 'NONE', sortMode: 'NONE', tagFilter: '*', type: 'PT_BRANCH'
      ),
      booleanParam(defaultValue: false, description: 'Please select to invite the new Members to Fuchicorp', name: 'INVITE_MEMBERS'),
      booleanParam(defaultValue: false, description: 'Please select to delete Members from Fuchicorp', name: 'DELETE_MEMBERS'),
      booleanParam(defaultValue: false, description: 'Please select to add  Members to Fuchicorp Teams ', name: 'ADD_USER_TEAM'),
      booleanParam(defaultValue: false, description: 'Please select to remove Members from Fuchicorp Teams', name: 'REMOVE_USER_TEAM'),
      text(defaultValue: '', description: 'Please enter github user per line to onboard the organization', name: 'GITHUB_USERNAME', trim: true),
      string(defaultValue: 'common-jenkins-admin', description: 'Please provide the name of the team in organization', name: 'ORG_TEAM_NAME', trim: true)
    ])
  ])
  
  podTemplate(name: k8slabel, label: k8slabel, yaml: slavePodTemplate, showRawYaml: false) {
    node(k8slabel){
      container("python-container") {
        withCredentials([usernamePassword(credentialsId: 'github-common-access', passwordVariable: 'GIT_TOKEN', usernameVariable: 'GIT_USERNAME')]) {
          stage("Pull Repo"){
            git branch: "${params.GIT_BRANCH}", credentialsId: 'github-common-access', url: 'https://github.com/fuchicorp/common_scripts.git'
          }
          stage("Getting Configurations"){
            println("Getting into the proper directory")
            dir('github-management/manage-users') {
              if (commonFunctions.isAdmin(triggerUser)) { 
                stage("Checking Previleges"){
                  echo "You have Admin privilege!!"
                  echo "You are allowed to run this Job!!"
                }
                stage("Installing Packages"){
                  sh 'pip3 install -r requirements.txt'
                }
                if (params.INVITE_MEMBERS) {  
                  stage("Inviting Members"){           
                    println("Sending invites to start now")
                    println("Members are being invited to join Fuchicorp from Github")
                    sh "python3 manage-github.py --invite"
                    println("Process is COMPLETE!!")
                  }
                } else if (params.DELETE_MEMBERS) {
                  stage("Deleting Members"){
                    println("Deletion start now")
                    println("Member(s) are being deleted from Fuchicorp on Github")
                    sh "python3 manage-github.py --delete"
                    println("Process is COMPLETE!!")
                   }
                 } else if (params.ADD_USER_TEAM) {
                  stage("Adding Members to ORG_TEAM_NAME"){
                    println("Adding start now")
                    println("Member(s) are being Added from Fuchicorp ORG_TEAM_NAME ")
                    sh "python3 manage-github.py --addUserTeam"
                    println("Process is COMPLETE!!")
                   }
                 } else if (params.REMOVE_USER_TEAM) {
                stage("removing Members from ORG_TEAM_NAME"){
                  println("removal start now")
                  println("Member(s) are being removed from Fuchicorp ORG_TEAM_NAME")
                  sh "python3 manage-github.py --removeUserTeam"
                  println("Process is COMPLETE!!")
                  }
                } else {
                  stage("No Selection"){
                    println("You did not make any selection.Please choose to invite, delete, addUserTeam or removeUserTeam members from Fuchicorp")
                  }
                }
              } else {
                  echo "Aborting... Requires Admin Access"
                  currentBuild.result = 'ABORTED'
                  error('You are not allowed to run this Jenkins Job.Please respect Fuchicorp Policies!!!')
              }
            }  
          } 
        }
      }
    }
  }
}

    
