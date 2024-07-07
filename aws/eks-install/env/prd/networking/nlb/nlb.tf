module "vars" {
  source = "../../vars"
}

provider "aws" {
  profile = module.vars.profile
  region  = module.vars.region
}

locals {
  target_alb    = "game2048-router-alb"
  main_domain   = "edu-tech.io"
  sub_domains   = ["jenkins.team"]
  domains       = [for subdomain in local.sub_domains : "${subdomain}.${local.main_domain}"]
  regex_domains = [for domain in local.domains : (
    length(split(".", domain)) < 3 
    ? domain 
    : regex("[^.]+\\.(.+)", domain)[0]
  )]
}

data "aws_lb" "target_alb" {
  name = local.target_alb
}

data "aws_route53_zone" "selected" {
  for_each = toset(local.regex_domains)
  name     = each.value
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket    = "${module.vars.cluster_name}-tfstate"
    key       = "State/VPC/terraform.tfstate"
    region    = module.vars.region
    profile   = module.vars.profile
  }
}

module "extenal_nlb_eip" {
  source            = "../../../../../shared/networking/eip"
  public_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets
  tags              = module.vars.tags
}

module "nlb" {
  source            = "../../../../../shared/networking/elb/nlb"
  elb_name          = "static-ip"
  target_prefix     = module.vars.tags.env
  vpc_id            = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.vpc.outputs.public_subnets
  eip_allocation_ids= module.extenal_nlb_eip.allocation_ids
  tags              = module.vars.tags

  depends_on        = [module.extenal_nlb_eip]
}

resource "aws_lb_target_group_attachment" "nlb_to_alb" {
  for_each = {
    for key, info in module.nlb.target_groups : key => info
  }

  target_group_arn = each.value.arn
  target_id        = data.aws_lb.target_alb.arn
  port             = each.value.port

  depends_on       = [module.nlb]
}

# 보류 -> 업데이트 미적용
# resource "aws_route53_record" "nlb_dns_record" {
#   for_each = data.aws_route53_zone.selected

#   zone_id = each.value.zone_id
#   name    = each.key
#   type    = "A"

#   alias {
#     name                   = module.nlb.dns_name
#     zone_id                = module.nlb.zone_id
#     evaluate_target_health = true
#   }
# }