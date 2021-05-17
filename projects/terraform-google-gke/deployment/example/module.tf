module "gke_cluster" {
    source  = "../../"
    cluster_name = "fuchicorp-cluster"
    google_region = "us-central1-c"
    google_project_id =  "flash-sol-311601"
    cluster_node_count = "2"
    cluster_version = "1.15"
    google_credentials = "./fuchicorp-service-account.json" # service account
    image_type        = "COS"
    disk_size_in_gb   = "10"
    machine_type      = "n1-standard-2"
    auto_repair     = true
    auto_upgrade    = false
    labels            = {
        "label" = "fuchicorp-project"
    }
}
