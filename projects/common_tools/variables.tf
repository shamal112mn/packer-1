
variable "credentials" {
  default = "common-service-account.json"
}

variable "deployment_environment" {
  default = "tools"
  description = "Namespace of the deployment <It will be created>"
}

variable "common_tools_access" {
  type = "list"
  default = [
        "10.40.0.13/8",      ## Cluster access
        "50.194.68.229/32",  ## Office IP1 
        "50.194.68.237/32",  ## Office IP2
        "24.12.115.204/32"   ## fsadykov home
  ]
}


variable "nexus" {
  type = "map"
  default = {
    admin_password     = "fuchicorp"
    docker_repo_port   = 8085
    nexus_docker_image = "quay.io/travelaudience/docker-nexus-proxy"
    username           = "admin"
  }
}

variable "sonarqube" {
  type = "map"
  default = {
    admin_password            = "fuchicorp"
    username                  = "admin"
    sonarqube_auth_client_id  = "id"
    sonarqube_auth_secret     = "secret"
  }
}

variable "tiller_namespace" {
  default     = "kube-system"
  description = "Tiller by default will deploy to kube-system"
}


variable "email" {
  default = "fuchicorpsolutions@gmail.com"
}

variable "google_project_id" {
  default = "angular-unison-267720"
}

variable "jenkins" {
  type = "map"

  default = {
    admin_user             = "admin"
    admin_password         = "password"
    jenkins_auth_client_id = "id"
    jenkins_auth_secret    = "secret"
    git_token              = "awdiahwd12ehhaiodd"
    slack_url              = "please-add-your-slack-url"
    slack_token            = "please-add-your-slack-token"
  }
}

variable "grafana" {
  type = "map"

  default = {
    grafana-version  = "6.0.1"
    grafana_username = "admin"
    grafana_password = "password"
    grafana-name     = "grafana"
    smtp_username    = "smtp-user"
    smtp_password    = "password"
    smtp_host        = "smtp.gmail.com:587"
    slack_url        = ""
    github_organization = "fuchicorp"
  }
}

variable "kube_dashboard" {
  type = "map"
  default {
    github_auth_client_id = "id"
    github_auth_secret    = "secret"
    github_organization   = "mkarimi20"
    proxy_cookie_secret   = "exampleproxysecret"
  }
}



variable "google_domain_name" {
  default = "fuchicorp.com"
  description = "Please change to your domain name"
}

variable "google_bucket_name" {
  description = "- (Required) please provied bucket name"
}

variable "deployment_name" {
  default = "common_tools"
}


variable "secret_config" {
  type = "map"

  default = {
    user_data = "admin:fuchicorp"
  }
  description = "- (Required) Variable is looking for <docker_endpoint> and  <docker_user_data> with following format (username:password)"
}


variable "namespaces" {
  type = "list"
  default = [
    "dev-students",
    "qa-students",
    "prod-students",
    "dev",
    "qa",
    "prod",
    "test",
    "stage",
    "elk"
  ]
  description = "- (Required) list of all namespaces for fuchicorp cluster"
}

variable "show_passwords" {
  default = "false"
  description = "- (Optional) if you put <true> output will show password."
}

variable "skip_github_organization" {
   default = "true"
   description = "- (Optional) if you put <true> output will enable organization true."
}

variable "grafana_dashboard_filenames" {
  default = [
    "cert-manager-dashboard-tpl",
    "ingress-controller-tpl",
    "jenkins-dashboard-tpl",
    "kubernetes-dashboard-tpl",
    "nexus-dashboard-tpl",
    "sonarqube-dashboard-tpl",
    "vault-dashboard-tpl",
    "external-dns-dashboard-tpl",
    "prometheus-dashboard-tpl",
    "waypoint-dashboard-tpl",
    ]
}
