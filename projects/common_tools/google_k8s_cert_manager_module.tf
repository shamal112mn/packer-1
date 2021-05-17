module "cert_manager_deploy" {
  source                 = "fuchicorp/chart/helm"
  deployment_name        = "cert-manager"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "cert-manager.${var.google_domain_name}"
  deployment_path        = "cert-manager"

  template_custom_vars = {
    null_depends_on = "${null_resource.cert_manager.id}"
  }
}

resource "null_resource" "cert_manager" {
  provisioner "local-exec" {
    command      = "helm repo add jetstack https://charts.jetstack.io"
  }
  depends_on = [
    "null_resource.helm_init" # optional if need to fit this in with other preceding resource
  ]
}

resource "null_resource" "cert_manager_crds" {
  provisioner "local-exec" {
    command      = "kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.1.0/cert-manager-legacy.crds.yaml"
  }
  depends_on = [
    "null_resource.cert_manager"
  ]
}