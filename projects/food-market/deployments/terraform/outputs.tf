output "application_deployed" {
  value = <<EOF
  


  ####################################################################################


  Hello ${var.deployment_environment} Team,

  Application has been succesfully deployed and configured. 
  If you would like to access to the application main page please click bellow link

  https://${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}

  Appliction is working on "${var.deployment_environment}" environment.


  ####################################################################################
  EOF
}