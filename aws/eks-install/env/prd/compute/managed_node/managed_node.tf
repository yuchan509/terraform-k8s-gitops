module "vars" {
  source = "../../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

module "important-app-node" {
  source = "../../../../modules/managed_node"
  eks_cluster_name  = module.vars.cluster_name
  cluster_version   = module.vars.cluster_version
  cluster_vpc_cidr  = module.vars.vpc_cidr_block
  node_group_name   = "important-app-node"
  labels            = {
                        env = "prd"
                        node-priority = module.vars.eks_node_priority.important
                      }
  taints            = {
                        priority = {
                          key    = "app-priority"
                          value  = module.vars.eks_node_priority.important
                          effect = "NO_SCHEDULE"
                        }
                      }
  min_size          = 1
  max_size          = 2
  desired_size      = 1 
  capacity_type     = "SPOT"
  instance_types    = ["t3.2xlarge"]
  tags              = module.vars.tags
}

