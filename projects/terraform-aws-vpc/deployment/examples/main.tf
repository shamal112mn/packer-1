module "vpc_eks" {
    source  = "git@github.com:fuchicorp/terraform-aws-vpc.git"

    ## This is used for VPC CIDR Block
    cidr_block = "10.0.0.0/16"

    region = "us-east-1" 
    cidr_block1_public = "10.0.1.0/24"
    cidr_block2_public = "10.0.2.0/24"
    cidr_block3_public = "10.0.3.0/24"
    cidr_block4_public = "10.0.4.0/24"

    cidr_block1_private = "10.0.101.0/24"
    cidr_block2_private = "10.0.102.0/24"
    cidr_block3_private = "10.0.103.0/24"
    cidr_block4_private = "10.0.104.0/24"

    ## Choose AZs to create subnets
    az1                  =       "us-east-1a"
    az2                  =       "us-east-1b"
    az3                  =       "us-east-1c"
    az4                  =       "us-east-1d"

                
}

