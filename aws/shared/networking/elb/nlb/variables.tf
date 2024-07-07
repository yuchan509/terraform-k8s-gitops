variable "elb_name" {
  description = "Name of the Elastic Load Balancer (ELB)"
  type        = string
}
variable "vpc_id" {
  description = "ID of VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "eip_allocation_ids" {
  description = "Elastic IP allocation IDs for the Target Group ALB"
  type        = map(string)
}

variable "target_prefix" {
  description = "Prefix for the Load Balancer targets"
  type        = string
}

variable "tags" {
  description = "Tags to assign to the AWS Load Balancer"
  type        = map(string)
}
