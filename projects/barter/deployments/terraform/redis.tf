module "redis-deploy" {
  source = "fuchicorp/chart/helm"

  deployment_name        = "redis"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = ""
  deployment_path        = "redis"

  template_custom_vars = {
    deployment_image = ""
  }
}