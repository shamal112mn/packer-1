resource "kubernetes_service_account" "dev_fuchicorp_service_account" {
  metadata {
    name = "dev-fuchicorp-service-account"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_binding" "dev_admin_role_binding" {
  metadata {
    name      = "dev-admin-role-binding"
    namespace = "dev"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fuchicorp-cluster-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "dev-fuchicorp-service-account"
    namespace = "kube-system"
  }
}
