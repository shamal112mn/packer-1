provider "aws" {
  profile    = "default"
  region     = "${var.region}"
  version    = "2.59"
}
