properties([
    parameters([
        booleanParam(defaultValue: false, description: 'Please select to apply the changes', name: 'terraform_apply'),
        booleanParam(defaultValue: false, description: 'Please select to destroy everything.', name: 'terraform_destroy'),
        booleanParam(defaultValue: false, description: 'Please select to run the job in debug mode', name: 'debugMode'),
        choice(choices: ['dev', 'qa', 'stage', 'prod'], description: 'Please select the environment to deploy.', name: 'environment'),
        choice(choices: ['us-west-2', 'us-west-1', 'us-east-2', 'us-east-1', 'eu-west-1'], description: 'Please select the region', name: 'region'),
        string(defaultValue: 'None', description: 'Please provide the docker image', name: 'selectedDockerImage', trim: true)
     ])
 ])

  def findDockerImageScript = '''
    import groovy.json.JsonSlurper
    def findDockerImages(branchName, domain_name) {
    def versionList = []
    def token       = ""
    def myJsonreader = new JsonSlurper()
    def nexusData = myJsonreader.parse(new URL("https://nexus.${domain_name}/service/rest/v1/components?repository=fuchicorp"))
    nexusData.items.each { if (it.name.contains(branchName)) { versionList.add(it.name + ":" + it.version) } }
    while (true) {
        if (nexusData.continuationToken) {
        token = nexusData.continuationToken
        nexusData = myJsonreader.parse(new URL("https://nexus.${domain_name}/service/rest/v1/components?repository=fuchicorp&continuationToken=${token}"))
        nexusData.items.each { if (it.name.contains(branchName)) { versionList.add(it.name + ":" + it.version) } }
        }
        if (nexusData.continuationToken == null ) { break } }
    if(!versionList) { versionList.add("ImmageNotFound") } 
    return versionList.reverse(true) }
    def domain_name     = "%s"
    def deployment_name = "%s"
    findDockerImages(deployment_name, domain_name)
    '''

def k8slabel        = "jenkins-pipeline-${UUID.randomUUID().toString()}"
def allEnvironments = ['dev', 'qa', 'stage', 'prod']
def deploymentName  = "${JOB_NAME}".split('/')[0].replace('-fuchicorp', '').replace('-build', '').replace('-deploy', '')
def domain_name     = ""
def timeStamp = Calendar.getInstance().getTime().format('ssmmhh-ddMMYYY',TimeZone.getTimeZone('CST'))
node('master') {
    // Getting the base domain name from Jenkins master < example: fuchicorp.com >
    domain_name = sh(returnStdout: true, script: 'echo $DOMAIN_NAME').trim()
}


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
            - name: buildtools
              image: fuchicorp/buildtools
              imagePullPolicy: IfNotPresent
              command:
              - cat
              tty: true
              volumeMounts:
                - mountPath: /etc/secrets/service-account/
                  name: google-service-account
                - mountPath: /var/run/docker.sock
                  name: docker-sock
            - name: docker
              image: docker:latest
              imagePullPolicy: IfNotPresent
              command:
              - cat
              tty: true
              volumeMounts:
                - mountPath: /etc/secrets/service-account/
                  name: google-service-account
                - mountPath: /var/run/docker.sock
                  name: docker-sock
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
 
    podTemplate(name: k8slabel, label: k8slabel, yaml: slavePodTemplate) {
      node(k8slabel) {
        timestamps {
          stage("Pulling the code") {
            git branch: 'dev-feature/7', credentialsId: 'github-creds', url: 'https://github.com/fuchicorp/data-miner.git'
          }
          
          container("buildtools") {
            dir('deployments/terraform/') {
              stage('Generate Configurations') {
                withEnv([ 
                    "GOOGLE_APPLICATION_CREDENTIALS=/etc/secrets/service-account/credentials.json"]) {
                      def deployment_tfvars = ""
                      sh """
                        cat  /etc/secrets/service-account/credentials.json > fuchicorp-service-account.json
                        ## This script should move to docker container to set up ~/.kube/config
                        sh /scripts/Dockerfile/set-config.sh
                      """
                      // sh /scripts/Dockerfile/set-config.sh Should go to Docker container CMD so we do not have to call on slave 
                      deployment_tfvars += """
                        credentials            = \"fuchicorp-service-account.json\"
                        deployment_name        = \"${deploymentName}\"
                        deployment_environment = \"${environment}\"
                        deployment_image       = \"docker.${domain_name}/${selectedDockerImage}\"
                        google_domain_name     = \"${domain_name}\"
                      """.stripIndent()

                      writeFile(
                        [file: "deployment_configuration.tfvars", text: "${deployment_tfvars}"]
                        )

                      if (params.debugMode) {
                        sh """
                          echo #############################################################
                          cat deployment_configuration.tfvars
                          echo #############################################################
                        """
                      }
                      
                      try {
                          withCredentials([
                              file(credentialsId: "${deploymentName}-config", variable: 'default_config')
                          ]) {
                              sh """
                                #!/bin/bash
                                cat \$default_config >> deployment_configuration.tfvars
                                
                              """
                              if (params.debugMode) {
                                sh """
                                  echo #############################################################
                                  cat deployment_configuration.tfvars
                                  echo #############################################################
                                """
                              }
                          }
                      
                          println("Found default configurations appanded to main configuration")
                      } catch (e) {
                          println("Default configurations not founds. Skiping!!")
                      }
                        
                    }
                  }



                  withCredentials([usernamePassword(credentialsId: "aws-access-${environment}", passwordVariable: 'AWS_SECRET_ACCESS_KEY', usernameVariable: 'AWS_ACCESS_KEY_ID')]) {

                    stage("Terraform Apply/plan") {
                      if (!params.terraform_destroy) {
                        if (params.terraform_apply) {
                          println("Applying the changes")
                          sh """
                          #!/bin/bash
                          export AWS_DEFAULT_REGION=${region}
                          terraform init
                          terraform apply -auto-approve -var-file deployment_configuration.tfvars
                          """
                        } else {
                          println("Planing the changes")
                          sh """
                          #!/bin/bash
                          set +ex
                          ls -l
                          export AWS_DEFAULT_REGION=${region}
                          terraform init
                          terraform plan -var-file deployment_configuration.tfvars
                          """
                        }
                      }
                    }

                    stage("Terraform Destroy") {
                      if (params.terraform_destroy) {
                        println("Destroying the all")
                        sh """
                        #!/bin/bash
                        export AWS_DEFAULT_REGION=${region}
                        terraform init
                        terraform destroy -auto-approve -var-file deployment_configuration.tfvars
                        """
                      } else {
                        println("Skiping the destroy")
                      }
                    }
                }
              }
            }
          }
        }
      } 
