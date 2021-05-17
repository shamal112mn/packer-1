
def k8slabel               = "jenkins-pipeline-${UUID.randomUUID().toString()}"

def WORKSPACE              = "${params.reponame}"

def slavePodTemplate = """
apiVersion: v1
kind: Pod
metadata:
  labels: 
    k8s-label: ${k8slabel}
  name: ${k8slabel}
  namespace: tools
spec:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
        matchExpressions:
        - key: app.kubernetes.io/component
          operator: In
          values:
          - jenkins-master
        topologyKey: "kubernetes.io/hostname"
  containers:
  - image: ikambarov/jnlp-agent-k8-tools
    name: k8-tools
    command:
    - sleep
    - 10000 
  serviceAccount: jenkins
"""

podTemplate(name: k8slabel, label: k8slabel, yaml: slavePodTemplate) {
    properties([
        parameters([
            booleanParam(defaultValue: true, description: 'Do you want to apply?', name: 'apply'),
            string(defaultValue: '$GIT_TOKEN', description: 'Provide github token:', name: 'gittoken', trim: true),
            string(defaultValue: 'fuchicorp', description: 'Provide github name:', name: 'gitname', trim: true),
            string(defaultValue: 'helm_charts', description: 'Provide repo name:', name: 'reponame', trim: true),
            string(defaultValue: '', description: 'Provide your email:', name: 'email', trim: true),
            string(defaultValue: '', description: 'Provide branch name:', name: 'branch_name', trim: true),


            ])
        ])

    node(k8slabel){
      withCredentials([string(credentialsId: 'git-common-token', variable: 'GIT_TOKEN')]){
                container('k8-tools'){
                  dir("${WORKSPACE}"){
                  stage('Clone Github repo& helm package/index') {
                    sh """
                    #!/bin/bash
                    git clone https://none:${params.gittoken}@github.com/${params.gitname}/${params.reponame}.git
                    cd ${params.reponame}/stable && git checkout -f "${params.branch_name}"
                    helm package * -d ../docs && cd ../docs && helm repo index --merge index.yaml .
                    git add .
                    git config --global user.email "${params.email}"
                    git config --global user.name "${params.gitname}"
                    git commit -m "Created all the files"
                    git push -u origin "${params.branch_name}"
                    """
                  }
                }
            }
        }
    }
}
