// PLEASE FOLLOW THESE DIRECTIONS TO DEPLOY HELLO-WORLD REPO
// https://github.com/fuchicorp/jenkins-global-library/wiki/Create-Hello-World-application-Repo
 
podTemplate{
    properties([ 
    parameters([
        booleanParam(defaultValue: false, description: 'Do you want to apply?', name: 'apply'),
        booleanParam(defaultValue: false, description: 'Do you want to destroy?', name: 'destroy'),
        string(defaultValue: '', description: 'Provide repo name:', name: 'reponame', trim: true),
        string(defaultValue: '', description: 'Provide github name:', name: 'gitname', trim: true),
        string(defaultValue: '', description: 'Provide github token:', name: 'gittoken', trim: true),
    ])
])

    node(POD_LABEL) {
    if(params.apply){
        stage('Creating repo and pushing the files') {
            try {
                sh """curl -u none:${params.gittoken}  https://api.github.com/user/repos -d '{"name":"${params.reponame}", "auto_init" : true}' """
                } catch (e) {
                    println(e.getMessage())
            }
            sh """
              #!/bin/bash
              git clone https://none:${params.gittoken}@github.com/${params.gitname}/${params.reponame}.git
              git clone --recurse-submodules https://github.com/fuchicorp/hello-world-app && mv hello-world-app/* ${params.reponame}/ && rm -rf hello-world-app
              cd ${params.reponame} && find deployments/terraform/charts/hello-world/ -type f -exec sed -i "s/name: hello-world/name: ${params.reponame}/g" {} \\;
              git add --all
              git config --global user.email "jenkins@fuchicorp.com"
              git config --global user.name "${params.gitname}"
              git commit -m "Created all the files"
              git push
              """   
        }
    }
    if(params.destroy){
        stage('Destroying the repo') {
                sh """curl -X DELETE -H "Accept: application/vnd.github.v3+json" -u none:${params.gittoken}   https://api.github.com/repos/${params.gitname}/${params.reponame}
                """
                } 
        }
    }
}

