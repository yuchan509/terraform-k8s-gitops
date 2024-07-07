data "aws_vpc" "eks" {
  tags = {
   "Name" = "${var.eks_cluster_name}-vpc"
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.eks_cluster_name
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks.id]
  }

  tags = {
    subnet_class = "private"
  }
}

data "aws_security_group" "node_group" {
  vpc_id = data.aws_vpc.eks.id

  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-node"]
  }
}