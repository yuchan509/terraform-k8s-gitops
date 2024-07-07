module "vars" {
  source = "../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

module "s3-csi-driver" {
  source           = "../../../../../shared/storage/s3_csi_driver"
  eks_cluster_name = module.local.cluster_name
  s3_bucket_name   = "model-deepseek-coder-7b-instruct-v1.5"
}