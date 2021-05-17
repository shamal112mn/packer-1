package com.lib
import groovy.json.JsonSlurper

def runPipeline() {

def k8slabel = "jenkins-pipeline-${UUID.randomUUID().toString()}"

// Getting common functions from jenkins global library
def commonFunctions        = new CommonFunction()

// Get username who run the job 
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
  podTemplate(name: k8slabel, label: k8slabel, yaml: slavePodTemplate, showRawYaml: false) {
    node(k8slabel) {
      properties([
        parameters([
          gitParameter(
            branch: '', branchFilter: 'origin/(.*)', defaultValue: 'master', 
            description: 'Please select the branch you would like to build ', 
            name: 'GIT_BRANCH', quickFilterEnabled: true, 
            selectedValue: 'NONE', sortMode: 'NONE', tagFilter: '*', type: 'PT_BRANCH'
          ),
          booleanParam(defaultValue: false, description: 'Do you want to sync all labels? ', name: 'SYNC_LABELS'),
          booleanParam(defaultValue: false, description: 'Do you want to !!DELETE ALL LABELS!!? ', name: 'DELETE_ALL_LABELS'),
          booleanParam(defaultValue: false, description: 'Do you want to delete all none managed labels?', name: 'DELETE_NONE_MANAGED_LABELS'),
        ]) 
      ])
              

          container("python-container"){
            withCredentials([usernamePassword(credentialsId: 'github-common-access', passwordVariable: 'GIT_TOKEN', usernameVariable: 'GIT_USERNAME')]) {
              stage("Pull SCM") {
                git branch: "${params.GIT_BRANCH}", credentialsId: 'github-common-access', url: 'https://github.com/fuchicorp/common_scripts.git'
              }
              
              stage("Installing Packages") {
                  sh 'pip3 install -r  github-management/manage-labels/requirements.txt'
              }
              
              stage("Running Script") {
                if (params.SYNC_LABELS) {
                  echo "Checking for Admin privilege"
                    if (commonFunctions.isAdmin(triggerUser)) {
                      echo "Starting creating/syncing process"
                      sh 'python3 github-management/manage-labels/sync-create-github-labels.py'
                      echo "Syncing process is COMPLETE!!"
                    } else {
                      echo "Aborting... Requires Admin Access"
                      currentBuild.result = 'ABORTED'
                      error('You are not allowed to sync labels!!!')
                    }
                } else {
                  echo "No seletion made. Skipping this stage!"
                }
              }

              stage("Deleting all labels") {
                if (params.DELETE_ALL_LABELS) {
                  echo "Checking for Admin privilege"
                    if (commonFunctions.isAdmin(triggerUser)) {                     
                      echo "You have Admin privilege!! Starting Deletion of Labels..."
                      sh 'python3 github-management/manage-labels/delete-github-labels.py --delete yes'
                      echo "Deleting All Labels is COMPLETE!!"
                    } else {
                      echo "Aborting... Requires Admin Access"
                      currentBuild.result = 'ABORTED'
                      error('You are not allowed to delete all labels!!!')
                    }
                } else {
                  echo "No selection made. Skipping this stage!"
                }
              }              

              stage("Deleting None Managed Labels") {
                if (params.DELETE_NONE_MANAGED_LABELS) {
                  echo "Checking for Admin privilege"
                    if (commonFunctions.isAdmin(triggerUser)) {
                      echo "Deleting all labels which is not inside labels.json file..."
                      sh 'python3 github-management/manage-labels/delete-not-managed-labels.py --delete yes'
                      echo "Deleting none managed labels is COMPLETE!!"
                    } else {
                      echo "Aborting... Requires Admin Access"
                      currentBuild.result = 'ABORTED'
                      error('You are not allowed to delete labels!!!')
                    }
                } else {
                  echo "No selection made. Skipping this stage!"
                }
              }
            }
          }
      }
    }
}