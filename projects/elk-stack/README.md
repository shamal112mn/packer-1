## Terraform module for ELK

To be able to use following terraform module please follow the documentation. 


## Requirements

* Terraform >= 0.11.14
* Helm >=2.8.0 and <3.0.0
* Kubernetes >=1.9
* You should have an access to your Kubernetes cluster

## Usage

Step 1. Clone repository
```
git clone https://github.com/fuchicorp/elk-stack.git
```

Step 2. Create `elk.tfvars` Please provide whitelisted ip ranges. It should look like this. 

```
deployment_name         = "elk"
deployment_environment  = "example-ns"
google_domain_name      = "examle-domain-name.com"
credentials             = "example-service-account.json"
google_bucket_name      = "examle-common"
google_project_id       = "example-278903"
elk = {
  whitelisted_ip_ranges    = "24.15.232.38/32, 50.194.68.229/32, 10.16.0.27/8"
}
```

Step 3. After you finish with defining all required variables go ahead and run `source set-env.sh elk.tfvars` and than run `terraform apply -var-file=$DATAFILE`

```
source set-env.sh elk.tfvars
terraform apply -var-file=$DATAFILE
```

## Calling module

Your `elk-module.tf` should look like this
```
module "kibana_deploy" {
  source  = "git::https://github.com/fuchicorp/helm-deploy.git"
  deployment_name        = "kibana"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "kibana.${var.google_domain_name}"
  deployment_path        = "kibana"
  
  template_custom_vars    = {
    kibana_ip_ranges      =  "${var.elk["whitelisted_ip_ranges"]}"
  }
}

module "filebeat_deploy" {
  
  source  = "fuchicorp/chart/helm" 
  deployment_name        = "filebeat"
  deployment_environment = "${var.deployment_environment}"
  deployment_path        = "filebeat"
  deployment_endpoint    = "filebeat-none.com" # filebeat doesn't have ingress resource 

  template_custom_vars   = {
    NODE_NAME = "$${NODE_NAME}"
    ELASTICSEARCH_HOSTS  = "$${ELASTICSEARCH_HOSTS:elasticsearch-master:9200}"
  }
}

  
module "elasticsearch_deploy" {
  
  source                 = "fuchicorp/chart/helm"
  deployment_name        = "${var.deployment_name}"
  deployment_environment = "${var.deployment_environment}"
  deployment_endpoint    = "elasticsearch.${var.google_domain_name}"
  deployment_path        = "elasticsearch"

  template_custom_vars         = {
      elasticsearch_ip_ranges  =  "${var.elk["whitelisted_ip_ranges"]}"
      http_code = "%%{http_code}"
    }
}
```

## Variables

For more info, please see the [variables file](?tab=inputs).

| Variable               | Description                         | Default                                               | Type |
| :--------------------- | :---------------------------------- | :---------------------------------------------------: | :--------------------: |
| `google_domain_name` | Relative name of the domain serving the application. | `(Required)` | `string` |
| `deployment_name` |  Name of your deployment. | `(Required)` | `string` |
| `deployment_environment` | Environment (namespace) where you want to deploy ELK | `(Required)` | `string` |
| `credentials` | Your google service account example.json | `(Required)` | `string` |
| `google_bucket_name` | The name of the bucket. | `(Required)` | `string` |
| `google_project_id` | The ID of the project in which the resource belongs. If it is not provided, the provider project is used | `(Required)` | `string` |




If you have any issues please feel free to submit the issue [new issue](https://github.com/fuchicorp/terraform-aws-eks/issues/new) 

Developed by FuchiCorp members 