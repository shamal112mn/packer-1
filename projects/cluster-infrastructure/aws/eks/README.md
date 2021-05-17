# EKS cluster deployment
#fuchicorp/docs/eks
### Author
Created by @fsadykov
Farkhod Sadykov
fsadykov.com
## Before you begin
1. Make sure you have terraform `11.14`
2. Make sure you have AWS account and access key
3. Make sure you have kubectl command installed
4. Make sure you have finished with VPC deployment
## Deployment
To be able to deploy the EKS cluster infrastructure. You will need to follow the below steps.
```
git clone git@github.com:fuchicorp/cluster-infrastructure.git
cd cluster-infrastructure/aws/eks
``` 
After you have everything download you will need to authenticate to AWS from environment variables. 
```
export AWS_ACCESS_KEY_ID='YOUR KEY ID'
export AWS_SECRET_ACCESS_KEY='YOUR SECRET ID'
```
Please reference to following `tfvars` to be able to deploy EKS cluster
```
## For set-env.sh script configurations
environment                     =   "dev"
region                          =   "us-east-1"
s3_bucket                       =   "fuchicorp"
s3_folder_region                =   "us-east-1"
s3_folder_project               =   "fuchicorp"
s3_folder_type                  =   "eks"
s3_tfstate_file                 =   "infrastructure.tfstate"
## After deployment of VPC you should have two security groups
security_group_ids = [
    "sg-0a54eeef73bcd0812",
    "sg-0eed094d5266aa574",
]
## Public Subnets for EKS 
public_subnets     = [
    "subnet-01d3fb52ab72ebc7b",
    "subnet-0a22ac955d82c430f",
    "subnet-04bc8caf7340e35d5",
    "subnet-0b6a7b9d8bd1faf2c",
    ]
## Private Subnets for EKS 
private_subnets     = [
    "subnet-06dd58631906ff870",
    "subnet-063d775af8c1a0690",
    "subnet-0e1b6507a37417261",
    "subnet-01ad9894683ae9d9e",
    ]
```
After that you will need to do second options
```
source set-env.sh configurations/dev/us-east-1.tfvars
terraform apply -var-file $DATAFILE -auto-approve 
```
To get access to cluster run follow command
```
aws eks --region us-east-1 update-kubeconfig --name fuchicorp
```
Example command 😊 
```
kubectl get nodes
NAME                         STATUS   ROLES    AGE     VERSION
ip-10-0-1-148.ec2.internal   Ready    <none>   4m42s   v1.15.11-eks-065dce
ip-10-0-4-62.ec2.internal    Ready    <none>   4m42s   v1.15.11-eks-065dce
```
