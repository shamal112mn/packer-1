provider "google" {
  credentials = "${file("./fuchicorp-service-account.json")}"
  project     = "${var.google_project_id}"
  zone        = "${var.zone}"
}



resource "google_compute_firewall" "default" {
  name    = "bastion-network-firewall-1"
  network = "${google_compute_instance.vm_instance.network_interface.0.network}"

  allow { protocol = "icmp" }
  allow { protocol = "tcp" ports = ["80", "443", "5000", "8080"] }

  source_ranges = ["0.0.0.0/0"]
  source_tags = ["bastion-firewall"]
}



resource "google_compute_instance" "vm_instance" {
  name         = "bastion-${replace(var.google_domain_name, ".", "-")}"
  machine_type = "${var.machine_type}"

  tags = ["bastion-firewall"]

  boot_disk {
    initialize_params {
      size = "${var.instance_disk_zie}" 
      image = "${var.ami_id}"
    }

  }

  network_interface {
    network       = "default"
    # network       = "${google_compute_network.vpc_network.name}"
    access_config = {}
  }
  
  metadata {
    sshKeys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = <<EOF
  echo 'export GIT_TOKEN="${var.git_common_token}"' >> /root/.bashrc 
  git clone https://${var.gce_ssh_user}:${var.git_common_token}@github.com/fuchicorp/common_scripts.git /common_scripts
  echo "* * * * * source /root/.bashrc && cd /common_scripts/bastion-scripts/ && python3 sync-users.py" > /sync-crontab
  echo "0 2 * * */2,4,6 /usr/bin/find /home -iname '.terraform' -exec rm -rf {} \; 2>/dev/null" >> /sync-crontab
  crontab /sync-crontab
  rm -rf /home/centos-cloud
EOF
}

resource "null_resource" "local_generate_kube_config" {
  depends_on = ["google_compute_instance.vm_instance"]
  provisioner "local-exec" {
    command = <<EOF
    #!/bin/bash
    until ping -c1 ${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip} >/dev/null 2>&1; do echo "Trying to connect bastion host '${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}' "; sleep 2; done
    wget -q "--header=Authorization: token ${var.git_common_token}" "https://raw.githubusercontent.com/fuchicorp/common_scripts/master/set-environments/kubernetes/set-kube-config.sh" -O set-env >/dev/null  
    ENDPOINT=$(kubectl get endpoints kubernetes | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    echo $ENDPOINT
    bash /common_scripts/set-environments/kubernetes/set-kube-config.sh $ENDPOINT
    ssh ${var.gce_ssh_user}@${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip} sudo mkdir /fuchicorp | echo 'Folder exist'
    scp -r  "admin_config"   ${var.gce_ssh_user}@${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}:~/
    scp -r  "view_config"   ${var.gce_ssh_user}@${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}:~/
    ssh ${var.gce_ssh_user}@${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip} sudo mv -f ~/*config /fuchicorp/
    rm -rf set-kube-config*
EOF
  }
}

## Disabled for now since we are adding record to new account 
# resource "google_dns_record_set" "fuchicorp" {
#   depends_on = ["google_compute_instance.vm_instance"]
#   managed_zone = "fuchicorp"
#   name         = "bastion.${var.google_domain_name}."
#   type         = "A"
#   ttl          = 300
#   rrdatas      = ["${google_compute_instance.vm_instance.network_interface.0.access_config.0.nat_ip}"]
# }
