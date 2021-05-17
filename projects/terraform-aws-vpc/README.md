# terraform-aws-vpc
FuchiCorp AWS VPC deployment module 
# terraform-aws-vpc
FuchiCorp AWS VPC deployment module 
**Terraform module for VPC**
To be able to use following terraform module please follow the documentation.
**Requirements**
Terraform >= 0.11.14
Required_providers :
- aws = "~> 2.53.0"
- null = "2.1.2"
- local = "1.4.0"
- template = "2.1.2"
- random = "2.2.1"

**Calling module**

Your `main.tf` should look like this;
 
    module "aws-vpc" {
          
    source = "fuchicorp/terraform-aws-vpc"
    
    cidr_block1_public = ""
    cidr_block2_public = ""
    cidr_block3_public = ""
    cidr_block4_public = ""

    cidr_block1_private = ""
    cidr_block2_private = ""
    cidr_block3_private = ""
    cidr_block4_private = ""

    az1                 = ""
    az2                 = ""
    az3                 = ""
    az4                 = ""

    region = ""
    cidr_block = ""  }


After you finish with defining all required variables go ahead and run terraform init
` terraform init`


In order to authenticate to aws accountyou need to export credentials. Run this commands

`export AWS_ACCESS_KEY_ID="accesskey`
 `export AWS_SECRET_ACCESS_KEY="secretkey"`
 ` export AWS_DEFAULT_REGION="us-west-2"`
  `terraform plan`

After you exported your credentials go ahead and apply

`terraform apply`


 **Variables**
For more info, please see the variables file.

Variable  | Description | Default
--------  | -----------  | -------
cidr_block |                   |                     (Required)
region      |                    | (Required)
cidr_block1_public |    |       (Required)
cidr_block2_public |     |     (Required)
cidr_block3_public |      |    (Required)
cidr_block4_public  |      |   (Required)
cidr_block1_private |       |  (Required)
cidr_block2_private |        | (Required)
cidr_block3_private |       |  (Required)
cidr_block4_private |        | (Required)
az1                            |       | (Required)
az2                            |       | (Required)
az3                            |        |(Required)
az4                            |       | (Required)


Developed by FuchiCorp members.


