# Create set-env.sh script for cluster tools


**Implement `set-env.sh` inside cluster-tools  to be able to run and store state files inside the bucket** 

* We can use `set-env.sh` example from common_tools
* We are not using ENVIRONMENT variable, which is essentially a namespace. Remove all codes of line with ENVIRONMENT variable from `set-env.sh` script.

* Create `cluster_tools.tfvars`

```
google_bucket_name        = "bucket-name"
deployment_name           = "cluster-tools"
google_project_id         = "project-id"
google_domain_name        = "example.com"
credentials               = "fuchicorp-service-account.json"
```

* Copy over `fuchicorp-service-account.json` to your working directory
* `cp -rf ~/cluster-infrastructure/kube-cluster/fuchicorp-service-account.json .`

* Run:
```
source set-env.sh cluster_tools.tfvars
terraform apply -var-file $DATAFILE
```

* Backend now is created and state files are kept in the bucket
