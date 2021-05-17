# Create a role for eks-cluster. It's required . Take an example from terraform.io 
# and adjust it for your needs (change name )

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# In order to attach the role to cluster we need iam role policy attachment
# Since we have Cluster policy and service policy we need two policy attachments

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_cluster_role.name}"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_cluster_role.name}"
}  

#  Create a resource for eks-master . Add version (optional) and security groups(optional)
#  Vpc_config is required. In this case name, role and other resources have interpolation described in variable.tf

resource "aws_eks_cluster" "eks_master" {
  name     = "${var.cluster_name}"
  role_arn = "${aws_iam_role.eks_cluster_role.arn}"
  version = "${var.cluster_version}"

  vpc_config {
    subnet_ids = "${var.subnet_ids}"
    security_group_ids = "${var.security_group_ids}"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
  ]
}

# Added outputs, it is optional

output "endpoint" {
  value = "${aws_eks_cluster.eks_master.endpoint}"
}

output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.eks_master.certificate_authority.0.data}"
}

output "cluster_name" {
  value = "${var.cluster_name}"
}

output "region" {
  value = "${var.region}"
}