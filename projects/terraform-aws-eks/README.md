## Terraform module for EKS

To be able to use following terraform module please follow the documentation. 


## Requirements

* Terraform >= 0.11.14

  Required_providers :
  * aws      =   "~> 2.53.0"
  * null     =   "2.1.2"
  * local    =   "1.4.0"
  * template =   "2.1.2"
  * random   =   "2.2.1"



## Calling module

Your `main.tf` should look like this
```
module "cluster-eks" {
  source = "fuchicorp/eks/aws"
  subnet_ids = ["subnet-", "subnet-"]
  region = "us-east-1"
  ssh_key_location = "${file("~/.ssh/id_rsa.pub")}"
  cluster_name = ""
  cluster_version = "1.15"
  instance_type = ""
  node_desired_capacity = ""
  node_min_size = ""
  node_max_size = ""
  security_group_ids = ["sg-"]
}
```

After you finish with defining all required variables go ahead and run `terraform init`

```
terraform init
```
In order to authenticate to the cluster you need to export credentials. Run this commands
```
export AWS_ACCESS_KEY_ID="accesskey"
export AWS_SECRET_ACCESS_KEY="secretkey"
export AWS_DEFAULT_REGION="us-west-2"
terraform plan
```


After you exported your credentials go ahead and apply 

To authenticate to your cluster you have to run this command

```
aws eks update-kubeconfig --name (name of your cluster)
```
## Variables

For more info, please see the [variables file](?tab=inputs).

| Variable               | Description                         | Default                                               | Type |
| :--------------------- | :---------------------------------- | :---------------------------------------------------: | :--------------------: |
| `subnet_ids` | List of subnet IDs. | `(Required)` | `list` |
| `cluster_name` |  Name of the EKS Cluster. | `(Required)` | `string` |
| `cluster_version` | Version of the cluster. | `(Required)` | `string` |
| `node_desired_capacity` | Desired number of worker nodes | `(Required)` | `string` |
| `node_min_size` | Minimum number of worker nodes | `(Required)` | `string` |
| ` node_max_size` | Maximum number of worker nodes | `(Required)` | `string` |
| `ssh_key_location` | EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group| `(Required)` | `string` |
| `security_group_ids` |List of security group | `(Required)` | `list` |
| `instance_type` | Set of instance types associated with the EKS Node Group | `(Required)` | `string` |



If you have any issues please feel free to submit the issue [new issue](https://github.com/fuchicorp/terraform-aws-eks/issues/new) 

Developed by FuchiCorp members 
