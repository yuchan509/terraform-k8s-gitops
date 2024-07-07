variable "lb_name" {
  description = "AWS ESC LB Name"
  type        = string
}

variable "vpc_id" {
  description = "AWS ESC VPC ID"
  type        = string
}

variable "vpc_cidr_block" {
  description = "AWS ESC VPC CIDR BLOCK"
  type        = string
}

variable "public_subnets" {
  description = "AWS ESC Public Subnet"
  type        = list(string)
}

variable "container_svc_name_01_port" {
  description = "AWS ESC SVC 01 Port"
  type        = number
}

variable "tags" {
  description = "AWS EKS Tags"
  type        = map(string)
}