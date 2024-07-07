data "aws_vpc" "eks" {
  tags = {
    "Name" = "${var.eks_cluster_name}-vpc"
  }
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

data "aws_subnet" "selected" {
  for_each = toset(data.aws_subnets.private_subnets.ids)
  id = each.value
}

module "efs" {
  source = "terraform-aws-modules/efs/aws"

  name           = "${var.eks_cluster_name}-EFS"
  encrypted      = true 

  lifecycle_policy = {
    transition_to_ia = "AFTER_30_DAYS"
  }

   mount_targets = {
    for subnet_id in data.aws_subnets.private_subnets.ids:
    data.aws_subnet.selected[subnet_id].availability_zone => {
      subnet_id = subnet_id
    } if data.aws_subnet.selected[subnet_id].availability_zone != null
  }
  
  security_group_name = var.eks_cluster_name
  security_group_description = "${var.eks_cluster_name} EFS security group"
  security_group_vpc_id      = data.aws_vpc.eks.id
  security_group_rules = {
    vpc = {
      description = "EFS ingress from VPC private subnets"
      cidr_blocks = [data.aws_vpc.eks.cidr_block]
    }
  }

  enable_backup_policy = true 
  create_replication_configuration = false

  tags = var.tags
}