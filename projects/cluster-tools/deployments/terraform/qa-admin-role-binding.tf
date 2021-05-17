resource "kubernetes_service_account" "qa_fuchicorp_service_account" {
  metadata {
    name = "qa-fuchicorp-service-account"
    namespace = "kube-system"
  }
}

resource "kubernetes_role_binding" "qa_admin_role_binding" {
  metadata {
    name      = "qa-admin-role-binding"
    namespace = "qa"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "fuchicorp-cluster-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "qa-fuchicorp-service-account"
    namespace = "kube-system"
  }
}