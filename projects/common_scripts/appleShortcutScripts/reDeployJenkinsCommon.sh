
#!/bin/bash

echo "## Getting kube config access"
gcloud container clusters get-credentials fuchicorp-cluster --zone us-west1-b

helm delete --purge jenkins-deployment-tools


echo "## Cloning the common tools"
if [[ ! -d "./common_tools" ]]; then
    git clone git@github.com:fuchicorp/common_tools.git 
else
    cd "./common_tools" 
    git checkout master && git pull
fi


echo "## Running the script to create backend.tf"
source ./set-env.sh common_tools.tfvars


echo "## Running the terraform apply "
terraform apply -var-file=$DATAFILE -auto-approve
