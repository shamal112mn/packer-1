## FuchiCorp Waypoint Deployment
module "waypoint_deploy" {
  source                 = "fuchicorp/chart/helm"
  deployment_name        = "waypoint"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "waypoint.${var.google_domain_name}"
  deployment_path        = "waypoint"

  template_custom_vars = {

    null_depends_on      = "${null_resource.cert_manager.id}"
    waypoint_ip_ranges      = "${join(",",var.common_tools_access)}"
  }
}
