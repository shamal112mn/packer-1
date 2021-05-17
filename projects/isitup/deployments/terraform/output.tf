data "template_file" "output" {
  template = "${file("output.txt")}"

  vars {
    Chart_version  = "${var.deployment_name}-${var.release_version}"
    Helm_release_name = "${var.deployment_name}-${var.deployment_environment}"
    Domain_name  = "${lookup(var.deployment_endpoint, "${var.deployment_environment}")}.${var.google_domain_name}"
  }
}

output "success" {
  value = "${data.template_file.output.rendered}"
}