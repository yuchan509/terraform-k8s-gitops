variable "node_group_name" {
  description = "AWS EKS Node Group Name"
  type        = string
}

variable "eks_cluster_name" {
  description = "AWS EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster Version"
  type        = string
}

variable "cluster_vpc_cidr" {
  description = "EKS VPC CIDR"
  type        = string
}

variable "min_size" {
  description = "AWS EKS Node Min Size"
  type        = string
  default     = "1"
}

variable "max_size" {
  description = "AWS EKS Node Max Size"
  type        = string
  default     = "2"
}

variable "desired_size" {
  description = "AWS EKS Node Desired Size"
  type        = string
  default     = "1"
}

variable "instance_types" {
  description = "EKS Node Instance Types"
  type        = list(string)
  default     = ["t3.large"]
}

variable "capacity_type" {
  description = "AWS Node Capacity Types"
  type        = string
  default     = "SPOT"
}

variable "labels" {
  description = "AWS Node Labels"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "AWS Node Taints"
  type        = any
  default     = {}
}

variable "ami_type" {
  description = "Type of the AMI"
  default     = "AL2_x86_64"
}

variable "block_device_volume_size" {
  description = "Size of the EBS volume in GiB"
  default     = 100
}

variable "block_device_volume_type" {
  description = "Type of the EBS volume"
  default     = "gp3"
}

variable "block_device_iops" {
  description = "IOPS for the EBS volume"
  default     = 3000
}

variable "block_device_throughput" {
  description = "Throughput for the EBS volume"
  default     = 150
}

variable "iam_role_additional_policies" {
  description = "Additional IAM policies to attach to the node group role"
  type        = map(string)
  default     = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

variable "tags" {
  description = "AWS EKS Tags"
  type        = map(string)
}
