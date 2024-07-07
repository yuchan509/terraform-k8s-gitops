#-------------------------------------------------
# 1. Terraform State Backend Configuration
#-------------------------------------------------

# Execute the following file to configure the backend:
# ./storage/tf_state/tf_state.tf

# Using S3 for both backend storage and state locking

#-------------------------------------------------
# 2. Production Common Variables Modules
#-------------------------------------------------

module "vars" {
  source = "./vars"
}

#-------------------------------------------------
# 3. Amazon VPC Configuration
#-------------------------------------------------

# Execute the following file to configure the VPC:
# ./networking/vpc/vpc.tf

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket    = "${module.vars.cluster_name}-tfstate"
    key       = "State/VPC/terraform.tfstate"
    region    = module.vars.region
    profile   = module.vars.profile
  }
}

#-------------------------------------------------
# 4. Amazon EKS Installation
#-------------------------------------------------

module "eks" {
  source                  = "../../modules/eks"
  cluster_name            = module.vars.cluster_name
  cluster_version         = module.vars.cluster_version
  eks_vpc_id              = data.terraform_remote_state.vpc.outputs.vpc_id
  eks_intra_subnets       = data.terraform_remote_state.vpc.outputs.intra_subnets
  eks_private_subnet_ids  = data.terraform_remote_state.vpc.outputs.private_subnets
  tags                    = module.vars.tags
}

#-------------------------------------------------
# 5. Amazon EKS Managed Add-ons (Pre-Installation)
#-------------------------------------------------

# You can replace the default AWS VPC CNI with other options like Calico or Cilium.

module "eks_managed_addons" {
  source                  ="../../modules/eks_addons (pre)"
  cluster_name            = module.vars.cluster_name
  cluster_version         = module.vars.cluster_version
  cluster_endpoint        = module.eks.cluster_endpoint
  oidc_provider_arn       = module.eks.oidc_provider_arn
  managed_node_groups     = module.eks.eks_managed_node_groups
  tags                    = module.vars.tags
}

#-------------------------------------------------
# 6. Amazon k8s Add-ons (Post-Installation)
#-------------------------------------------------

# Execute the following file to configure the Kubernetes add-ons:
# ./k8s_addons/k8s_addons.tf

# If you've reached this point, the EKS installation is complete.