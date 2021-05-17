variable "deployment_environment" {
    default = "dev"
    description = "- (Required) Environment or namespace for application"
}

variable "deployment_name" {
  default = "food-market"
  default = "- (Required) The deployment name"
}

variable "deployment_endpoint" {
  type = "map"

  default = {
    test  = "test.food-market"
    dev  = "dev.food-market"
    qa   = "qa.food-market"
    prod = "food-market"
    stage = "stage.food-market"
  }
} 
variable "google_domain_name" {
    default = "fuchicorp.com"
}

variable "deployment_image" {
  default = "nginx"
  description = "- (Required) Docker image location docker.fuchicorp.com"
}

