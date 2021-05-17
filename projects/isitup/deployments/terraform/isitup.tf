module "isitup-deploy" {
  source  = "fuchicorp/chart/helm"

  deployment_name        = "isitup"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}" 
  deployment_path        = "isitup"
  template_custom_vars   = {     
    deployment_image     = "${var.deployment_image}"  
    github_organization  = "${var.github_organization}" 
    isitup_credentials   = "${kubernetes_secret.isitup_credentials.metadata.0.name}"
    debug_mode           = "'${lower(var.deployment_environment) == "prod" ? "False" : "True" }'"
    git_token            = "${var.git_token}" 
  }
}

resource "kubernetes_secret" "isitup_credentials" {
    "metadata" {
        name                = "isitup-credentials"
        namespace           = "${var.deployment_environment}"
    }

    data {
        mysql_user           = "${lookup(var.mysql[var.deployment_environment],  "mysql_user")}"
        mysql_database       = "${lookup(var.mysql[var.deployment_environment],  "mysql_database")}"
        mysql_password       = "${lookup(var.mysql[var.deployment_environment],  "mysql_password")}"
        mysql_host           = "${lookup(var.mysql[var.deployment_environment],  "mysql_host")}"
        mysql_root_password  = "${lookup(var.mysql[var.deployment_environment], "mysql_root_password")}"
        github-client-id     = "${lookup(var.github_client_id, "${var.deployment_environment}")}"
        github-secret        = "${lookup(var.github_secret, "${var.deployment_environment}")}"
    }
}

