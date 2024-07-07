#-------------------------------------------------
# 3. Amazon VPC Configuration
#-------------------------------------------------

module "vars" {
  source = "../../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

module "vpc" {
  source           = "../../../../modules/vpc"
  eks_cluster_name = module.vars.cluster_name
  vpc_cidr_block   = module.vars.vpc_cidr_block
  azs              = module.vars.azs
  tags             = module.vars.tags
}
