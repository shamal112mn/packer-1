module "api-deploy" {
  source  = "fuchicorp/chart/helm"

  deployment_name        = "api-platform"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
  deployment_path        = "api-platform"

  template_custom_vars  = {
    mysql_password       = "${var.mysql_password}"
    mysql_root_password  = "${var.mysql_root_password}"
    mysql_user           = "${var.mysql_user}"
    mysql_database       = "${var.mysql_database}"
    deployment_image    = "${var.deployment_image}"
  }
}
