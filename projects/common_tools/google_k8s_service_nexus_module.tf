module "nexus_deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "nexus"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "nexus.${var.google_domain_name}"
  deployment_path        = "sonatype-nexus"

  template_custom_vars = {
    null_depends_on          = "${null_resource.helm_init.id}"
    docker_endpoint          = "docker.${var.google_domain_name}"
    docker_repo_port         = "${var.nexus["docker_repo_port"]}"
    nexus_password           = "${var.nexus["admin_password"]}"
    nexus_docker_image       = "${var.nexus["nexus_docker_image"]}"
    nexus_ip_ranges          = "${join(",",var.common_tools_access)}"
    nexus_pvc                = "${kubernetes_persistent_volume_claim.nexus_pv_claim.metadata.0.name}"
  }
}

resource "kubernetes_persistent_volume_claim" "nexus_pv_claim" {
  metadata {
    name = "nexus"
    namespace = "${kubernetes_namespace.service_tools.metadata.0.name}"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests {
        storage = "30Gi"
      }
    }
    storage_class_name = "standard"
  }
  lifecycle {
     prevent_destroy = "false"
  }
}