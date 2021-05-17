resource "kubernetes_secret" "github_common_access"{
    metadata {
        name = "github-common-access"
        namespace = "tools"
        labels = {
            "jenkins.io/credentials-type" = "usernamePassword"
            }
        annotations = {
            "jenkins.io/credentials-description" = "Github Creds"
           }
    }
    data = {
         "username" = "${var.jenkins["git_username"]}"
         "password" = "${var.jenkins["git_token"]}"
    }
}