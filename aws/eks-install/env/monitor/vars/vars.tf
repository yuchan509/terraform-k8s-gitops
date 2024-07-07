data "aws_availability_zones" "available" {}

locals {
  profile         = "root"
  region          = "ap-northeast-2"
  
  cluster_name    = "monitor-eks-cluster"
  cluster_version = "1.29"

  vpc_cidr_block  = "10.31.0.0/16"
  azs             = ["ap-northeast-2a", "ap-northeast-2c"]
  
  eks_node_priority = {
    critical      = "critical"
    important     = "important"
    moderate      = "moderate"
    minor         = "minor"
    insignificant = "insignificant"
  }

  tags = {
    env        = "monitor"
    team       = "dx-solution"
    managed_by = "yuchan"
  }
}