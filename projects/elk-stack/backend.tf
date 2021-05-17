terraform {
  backend "gcs" {
    bucket  = "fuchicorp-common"
    prefix  = "elk/elk"
    project = "solid-antler-278903"
  }
}
