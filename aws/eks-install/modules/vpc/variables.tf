variable "eks_cluster_name" {
  description = "AWS EKS Cluster Name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Singla NAT Gateway"
  type        = bool
  default     = false
}

variable "one_nat_gateway_per_az" {
  description = "One NAT Gateway Per AZs"
  type        = bool
  default     = true
}

variable "tags" {
  description = "AWS EKS Tags"
  type        = map(string)
}