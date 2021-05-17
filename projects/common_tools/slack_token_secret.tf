resource "kubernetes_secret" "slack_token" {
  metadata {
    name = "slack-token"
    namespace = "tools"

    labels = {
      "jenkins.io/credentials-type" = "secretText"
      
    }

    annotations = {
      "jenkins.io/credentials-description" = "Slack Creds"
    }
  }
  
  data = {
    "text" = "${var.jenkins["slack_token"]}"
  }
}
