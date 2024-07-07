variable "cluster_name" {
  description = "AWS EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster version"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  type        = string
}

variable "managed_node_groups" {
  description = "AWS EKS EKS managed node groups"
  type        = map
}

variable "tags" {
  description = "AWS EKS Tags"
  type        = map(string)
}