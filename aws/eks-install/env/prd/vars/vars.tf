data "aws_availability_zones" "available" {}

locals {
  profile         = "root"
  region          = "ap-northeast-2"
  
  cluster_name    = "prd-eks-cluster"
  cluster_version = "1.29"

  vpc_cidr_block  = "10.11.0.0/16"
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  
  eks_node_priority = {
    critical      = "critical"
    important     = "important"
    moderate      = "moderate"
    minor         = "minor"
    insignificant = "insignificant"
  }

  tags = {
    env        = "prd"
    team       = "dx-solution"
    managed_by = "yuchan"
  }
}