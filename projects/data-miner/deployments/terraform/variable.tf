variable "deployment_endpoint" {
  type = "map"

  default = {
    dev    = "dev.dataminer"
    qa     = "qa.dataminer"
    prod   = "dataminer"
    stage  = "stage.dataminer"
  }
}

variable "mysql_db"  {
  type = "map"
  default = { 
    region                   = "us-east-1"
    mysql_name               = "aws_db_name"
    username                 = "username"
    password                 = "password"
  }
}


variable "deployment_image" {
  default = "docker.tubaloughlin.com/data-miner:17953f0"
}


variable "deployment_environment" {
  default = "dev"
}

variable "google_domain_name" {
  default = "tubaloughlin.com"
}

variable "whitelisted_cidrs" {
  type = "map"
  default = {
    prod  = "0.0.0.0/0"
    qa    = "10.16.0.27/8, 50.194.68.229/32, 50.194.68.230/32, 208.59.166.13/32"
    dev   = "10.16.0.27/8, 50.194.68.229/32, 50.194.68.230/32, 208.59.166.13/32"
    stage = "10.16.0.27/8, 50.194.68.229/32, 50.194.68.230/32, 208.59.166.13/32"
  }
}
