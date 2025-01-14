module "barter-deploy" {
  source = "fuchicorp/chart/helm"

  deployment_name        = "barter-app-chart"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
  deployment_path        = "barter-app-chart"

  template_custom_vars = {
    deployment_image = "${var.deployment_image}"
  }
}

output "application_endpoint" {
  value = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
}
