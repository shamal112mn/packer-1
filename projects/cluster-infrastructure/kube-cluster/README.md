# Google Cloud Platform Kubernetes Cluster Terraform Module
#fuchicorp/docs

Last update 2020-08-28


## Cluster deployment
In order to deploy kubernetes cluster in GCP. You need to clone a cluster-infrastructure repository from Fuchicorp and go to the kube-cluster folder 
```
git clone https://github.com/fuchicorp/cluster-infrastructure.git
cd cluster-infrastructure/kube-cluster/
```



### Set up Google Cloud Platform 
First you will need to authenticate to Google Cloud platform to be able to set-up from local
```
gcloud auth login
```

After you login you will need to set the project bay following command

```
gcloud projects list # Get the project ID and use it in the next command
gcloud config set project $YOUR PROJECT ID 
```
This script creates a service account and binds the following roles to it. It also creates JSON `fuchicorp-service-account.json` file for your service account and bucket. When you run the script you have to provide as user input unique bucket name ( in our example it is fuchicorp-example-bucket)
```
source setup-google-platform.sh fuchicorp-example-bucket
```



### Create terraform configuration 
Create `cluster.tfvars` file with following content:
```
google_domain_name       = "yourdomain.com"
google_project_id        = "GOOGLE_PROJECT_ID"
google_email             = "example@gmail.com"
cluster_version          = "1.16"
google_bucket_name       = "fuchicorp-gulshen"
deployment_environment   = "tools"
google_credentials_json  = "fuchicorp-service-account.json"
deployment_name          = "cluster-infrastructure"
google_region            = "us-west1-b"
```

### Terraform apply 
Use the set-env.sh file to be able to set up local environment variables
```    
source set-env.sh cluster.tfvars
```

We need to plan all changes before applying them. 
```
terraform plan -var-file=$DATAFILE ## Displays what would be executed
```

For applying all changes we need to run the following command:
```
terraform apply  -var-file=$DATAFILE
```



### The terraform will create following resources on Google Cloud Platform
1. Kubernetes cluster  `fuchicorp-cluster`
2. DNS Nameserver   `cluster-infrastructure-zone`
3. Google Service Account `common-service-account`

After you have deployed you should use following command to get `~/.kube/config` to be able to get access to kubernetes cluster
```
gcloud container clusters get-credentials fuchicorp-cluster --zone us-west1-b
```
