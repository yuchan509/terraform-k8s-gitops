variable "cluster_name" {
  description = "AWS EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster version"
  type        = string
}

variable "eks_vpc_id" {
  description = "EKS VPC ID"
  type        = string
}

variable "eks_intra_subnets" {
  description = "EKS ControlPlane Subnet IDs"
  type        = list(string)
}

variable "eks_private_subnet_ids" {
  description = "AWS EKS Private Subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "AWS EKS Tags"
  type        = map(string)
}