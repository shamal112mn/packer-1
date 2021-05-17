resource "kubernetes_service_account" "stage_fuchicorp_service_account" {
  metadata {
    name = "stage-fuchicorp-service-account"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_binding" "stage_admin_role_binding" {
  metadata {
    name      = "stage-admin-role-binding"
    namespace = "stage"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fuchicorp-cluster-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "stage-fuchicorp-service-account"
    namespace = "kube-system"
  }
}