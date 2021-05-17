
module "kibana_deploy" {
  source  = "git::https://github.com/fuchicorp/helm-deploy.git"
  deployment_name        = "kibana"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "kibana.${var.google_domain_name}"
  deployment_path        = "kibana"
  
  template_custom_vars    = {
    # null_depends_on         = "${module.elasticsearch_deploy}"
    kibana_ip_ranges          =  "${var.elk["whitelisted_ip_ranges"]}"
  
  }
}

module "filebeat_deploy" {
  
  source  = "fuchicorp/chart/helm" 
  deployment_name        = "filebeat"
  deployment_environment = "${var.deployment_environment}"
  deployment_path        = "filebeat"
  deployment_endpoint    = "filebeat-none.com" # filebeat doesn't have ingress resource 

  template_custom_vars   = {

    ## null_depends_on      = "${module.elasticsearch_deploy.local_file.deployment_values.id}" 
    ## https://github.com/fuchicorp/helm_charts/issues/83 

    NODE_NAME = "$${NODE_NAME}"
    ELASTICSEARCH_HOSTS = "$${ELASTICSEARCH_HOSTS:elasticsearch-master:9200}"
  }
}

  
module "elasticsearch_deploy" {
  
  source                 = "fuchicorp/chart/helm"
  deployment_name        = "${var.deployment_name}"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "elasticsearch.${var.google_domain_name}"
  deployment_path        = "elasticsearch"

  template_custom_vars    = {
      elasticsearch_ip_ranges    =  "${var.elk["whitelisted_ip_ranges"]}"
      http_code = "%%{http_code}"
    }
}
