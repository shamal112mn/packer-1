variable "deployment_endpoint" {
  type = "map"

  default = {
    test  = "test.isitup"
    dev  = "dev.isitup"
    qa   = "qa.isitup"
    prod = "isitup"
    stage = "stage.isitup"
  }
}

variable "deployment_name" {
  default = "isitup"
  description = "mysql-deployment"
}

variable "release_version" {
   description = "(Required) Specify the exact chart version to install"
   default     = " 0.5.8"
}

variable "deployment_image" {
  default = "fsadykov/isitup"
}

variable "git_token" {
}

variable "deployment_environment" {
  default = "dev"
}

variable "google_domain_name" {
  default = "fuchicorp.com"
}

variable "github_client_id" {
  type = "map"

  default = {
    test  = "github_client_id"
    dev  = "github_client_id"
    qa   = "github_client_id"
    prod = "github_client_id"
    stage = "github_client_id"
  }
}

variable "github_secret" {
  type = "map"

  default = {
    test  = "github_secret"
    dev  = "github_secret"
    qa   = "github_secret"
    prod = "github_secret"
    stage = "github_secret"
  }
}

variable "github_organization" {
  default = ""
}

variable "mysql" {
  type = "map"
}

variable "mysql_host" {
  default = "dev.isitup.hyavuz.com"
}
