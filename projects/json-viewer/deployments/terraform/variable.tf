variable "deployment_environment" {
  default = "dev"
}

variable "deployment_image" {
  default = "nginx:stable"
}

variable "deployment_endpoint" {
  type = "map"

  default = {
    dev   = "dev.jsonviewer"
    qa    = "qa.jsonviewer"
    prod  = "jsonviewer"
    stage = "stage.jsonviewer"
  }
}

variable "google_domain_name" {
  default = "fuchicorp.com"
}
