module "vars" {
  source = "../../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

module "efs" {
  source = "../../../../../shared/storage/efs"
  eks_cluster_name = module.vars.cluster_name
  tags             = module.vars.tags
}