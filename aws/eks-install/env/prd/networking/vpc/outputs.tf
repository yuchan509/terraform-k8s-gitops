output "vpc_id" {
  description = "EKS VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "The list of public subnets"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "The list of private subnets"
  value       = module.vpc.private_subnets
}

output "intra_subnets" {
  description = "The list of intrea subnets"
  value       = module.vpc.intra_subnets
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "public_route_table_ids" {
  description = "The list of public route table ids"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "The list of private route table ids"
  value       = module.vpc.private_route_table_ids
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = formatlist("%s/32", module.vpc.nat_public_ips)
}