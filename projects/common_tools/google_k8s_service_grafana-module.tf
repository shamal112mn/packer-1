module "grafana_deploy" {
  source  = "fuchicorp/chart/helm"
  deployment_name        = "${var.grafana["grafana-name"]}"
  deployment_environment = "${kubernetes_namespace.service_tools.metadata.0.name}"
  deployment_endpoint    = "grafana.${var.google_domain_name}"
  deployment_path        = "grafana"

  template_custom_vars = {

    null_depends_on          = "${null_resource.cert_manager.id}"
    datasource_dns_endpoint  = "https://prometheus.${var.google_domain_name}"
    grafana_password         = "${var.grafana["grafana_password"]}"
    grafana_username         = "${var.grafana["grafana_username"]}"
    grafana_client_secret    = "${var.grafana["grafana_client_secret"]}"
    grafana_auth_client_id   = "${var.grafana["grafana_auth_client_id"]}"
    github_organization      = "${var.grafana["github_organization"]}"

    smtp_user                = "${var.grafana["smtp_username"]}"
    smtp_password            = "${var.grafana["smtp_password"]}"
    smtp_host                = "${var.grafana["smtp_host"]}"
    grafana_ip_ranges        = "${join(",",var.common_tools_access)}"
    slack_url                = "${var.grafana["slack_url"]}"
  
    
  }
}

## input template dashboards for grafana
data "template_file" "dashboards" {
  count     = "${length(var.grafana_dashboard_filenames)}"
  template  = "${file("terraform_templates/grafana_dashboards/${var.grafana_dashboard_filenames[count.index]}")}"
  vars {
    GOOGLE_DOMAIN_NAME = "${var.google_domain_name}"
  }
}

## Output files directly will be used for grafana
resource "local_file" "output_dashboards" {
  count       = "${length(var.grafana_dashboard_filenames)}"
  content     = "${element(data.template_file.dashboards.*.rendered, count.index)}"
  filename    = "${"charts/grafana/dashboards/${var.grafana_dashboard_filenames[count.index]}"}-ignoreme.json"
}