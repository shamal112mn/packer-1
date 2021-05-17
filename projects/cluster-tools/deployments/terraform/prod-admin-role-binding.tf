resource "kubernetes_service_account" "prod_fuchicorp_service_account" {
  metadata {
    name = "prod-fuchicorp-service-account"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_binding" "prod_admin_role_binding" {
  metadata {
    name      = "prod-admin-role-binding"
    namespace = "prod"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fuchicorp-cluster-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "prod-fuchicorp-service-account"
    namespace = "kube-system"
  }
}