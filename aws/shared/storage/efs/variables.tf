variable "eks_cluster_name" {
  description = "AWS EKS Cluster Name"
  type = string
}

variable "tags" {
  description = "AWS EFS Tags"
  type = map(string)
}