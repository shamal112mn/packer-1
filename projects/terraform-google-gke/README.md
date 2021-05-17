## Terraform module for GKE with custom buckets

To be able to use following terraform module please follow the documentation. 


## Requirements

* Terraform >= 0.11.14
* provider.google: version = "~> 2.20"



## Calling module

Your `main.tf` should look like this
```
module "gke_cluster" {
    source  = "fuchicorp/gke/google"
    cluster_name = "fuchicorp-cluster"
    google_region = "us-central1"
    google_project_id = "fsadykov-project"
    cluster_node_count = "2"
    cluster_version = "1.15"
    google_credentials = "./fuchicorp-service-account.json" # service account 
    image_type        = "COS"
    disk_size_in_gb   = "10"
    labels            = {
        "label" = "fuchicorp-project"
    }
}
```

After you finish with defining all required variables go ahead and run `terraform init`

```
terraform init
```

After terraform finish with initialization go ahead and apply 

## Variables

For more info, please see the [variables file](?tab=inputs).

| Variable               | Description                         | Default                                               | Type |
| :--------------------- | :---------------------------------- | :---------------------------------------------------: | :--------------------: |
| `google_project_id` | Google account project id | `(Required)` | `string` |
| `google_region` | Name of the namespace | `(Required)` | `string` |
| `cluster_version` | Version of the cluster. | `(Required)` | `string` |
| `cluster_node_count` | Number of nodes for the cluster. | `(Required)` | `string` |
| `google_credentials` | your google service account `example.json`| `(Required)` | `string` |
| `cluster_network` |The name or self_link of the Google Compute Engine network to which the cluster is connected. | `(Optional)` | `string` |
| `cluster_name` | The name of the cluster, unique within the project and location. | `(Required)` | `string` |
| `machine_type` | The name of a Google Compute Engine machine type. | `(Optional)` | `string` |
| image_type     | The disk side of each node in the cluster         |  `(Optional)`| `string`  |  
| labels         | The label of the node in the cluster.             |  `(optional) | `map`| 
| `auto_upgrade`  |  The autoupgrade of the node in the cluster.     |  `(optional)` |  `string`  |                                         |              |
| `auto_repair`   |  The autorepair of the node in the cluster.     |  `(optional)` |  `string`  |  

If you have any issues please feel free to submit the issue [new issue](https://github.com/fuchicorp/terraform-google-gke/issues/new) 

Developed by FuchiCorp members 

