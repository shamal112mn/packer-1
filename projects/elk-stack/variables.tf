
variable "google_domain_name" {
    type = "string"
    description = "– (Required) Relative name of the domain serving the application."
}

variable "elk" {
    type = "map"
    description = "– (Required) Whitelisted ip's."
    default = { 
        whitelisted_ip_ranges = "0.0.0.0/0"
    }
}


variable "deployment_name" {
    type = "string"
    description = "– (Required) Name of your deployment."
}

variable "deployment_environment" {
    type = "string"
    description = "– (Required) Environment (namespace) where you want to deploy ELK."
}
