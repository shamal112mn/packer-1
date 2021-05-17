module "ingress_controller" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "ingress-controller"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "ingress.${var.google_domain_name}"
  deployment_path        = "./ingress-controller"
  template_custom_vars   = {
    null_depends_on      = "${null_resource.cert_manager.id}"
  }
}
