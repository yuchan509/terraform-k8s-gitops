output "profile" {
    description = "AWS Configure Profile"
    value       = local.profile
}

output "region" {
    description = "AWS Region"
    value       = local.region
}

output "azs" {
    description = "AWS AZs"
    value       = local.azs
}

output "cluster_name" {
  description = "AWS EKS Cluster Name"
  value       = local.cluster_name
}

output "cluster_version" {
  description = "EKS Cluster version"
  value       = local.cluster_version
}

output "vpc_cidr_block" {
  description = "EKS VPC CIDR Block"
  value       = local.vpc_cidr_block
}

output "eks_node_priority" {
  description = "Node Priority of EKS"
  value       = local.eks_node_priority
}

output "tags" {
    description = "AWS EKS Tags"
    value       = local.tags
}