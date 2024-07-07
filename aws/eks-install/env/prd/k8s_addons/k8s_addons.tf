#-------------------------------------------------
# 6. Amazon k8s Add-ons (Post-Installation)
#-------------------------------------------------

module "vars" {
  source = "../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket    = "${module.vars.cluster_name}-tfstate"
    key       = "State/EKS/terraform.tfstate"
    region    = module.vars.region
    profile   = module.vars.profile
  }
}

module "k8s_addons" {
  source                  ="../../../modules/k8s_addons (post)"
  cluster_name            = module.vars.cluster_name
  cluster_version         = module.vars.cluster_version
  cluster_endpoint        = data.terraform_remote_state.eks.outputs.cluster_endpoint
  oidc_provider_arn       = data.terraform_remote_state.eks.outputs.oidc_provider_arn
  addons_enable           = {
                              external_dns                  = true
                              aws_load_balancer_controller  = true
                              aws_efs_csi_driver            = true
                              karpenter                     = true
                              metrics_server                = true
                              nvidia_device_plugin          = true
                              keda                          = true
                            }
  tags                    = module.vars.tags
}