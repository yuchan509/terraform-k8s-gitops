output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = data.aws_security_group.node_group.id
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster."
  value       = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id
}