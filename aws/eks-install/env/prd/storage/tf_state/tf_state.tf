module "vars" {
  source = "../../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

module "s3-tfstate" {
  source           = "../../../../../shared/storage/s3_bucket"
  s3_bucket_name   = "${module.vars.cluster_name}-tfstate"
  tags             = module.vars.tags
}

module "Locking_dynamodb_table" {
  source           = "../../../../../shared/storage/dynamodb_table"
  table_name       = "${module.vars.cluster_name}-TerraformStateLock"
  tags             = module.vars.tags
}