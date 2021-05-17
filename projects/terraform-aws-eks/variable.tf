variable "subnet_ids" {
    type = "list"
    description = "– (Required) List of subnet IDs. "
}

variable "security_group_ids" {
    type = "list"
    description = "– (Required) List of security group"
}

variable "ssh_key_location" {
    type = "string"
    description = "- (Required) EC2 Key Pair name that provides access for SSH communication with the worker nodes in the EKS Node Group"
}

variable "cluster_name" {
    type = "string"
    description = "- (Required) Name of the EKS Cluster."
}

variable "instance_type" {
    type = "string"
    description = "- (Required) Set of instance types associated with the EKS Node Group. Defaults to t3.medium"
}

variable "node_desired_capacity" {
    type = "string"
    description = "- (Required) Desired number of worker nodes"
}

variable "node_min_size" {
    type = "string"
    description = "(Required) Minimum number of worker nodes"
}

variable "node_max_size" {
    type = "string"
    description = " - (Required) Maximum number of worker nodes"
}

variable "cluster_version" {
  type = "string"
  description = "- (Required) Version of the cluster"
}

variable "region" {
    type = "string"
    description = "- (Required) region of the cluster"
}
