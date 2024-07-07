# Define the VPC module
module "vpc" {
  source          = "terraform-aws-modules/vpc/aws"   # Source and version of the VPC module
  version         = "~>5.5.1"

  # VPC settings
  name            = "${var.eks_cluster_name}-vpc"     # Name of the VPC
  cidr            = var.vpc_cidr_block                # CIDR block for the VPC

  # Availability Zones and Subnet configurations
  azs             = var.azs                                                            # Availability Zones in the region
  private_subnets = [for k, v in var.azs : cidrsubnet(var.vpc_cidr_block, 4, k)]       # Private subnets (/20 CIDR)
  public_subnets  = [for k, v in var.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 48)]  # Public subnets (/24 CIDR)
  intra_subnets   = [for k, v in var.azs : cidrsubnet(var.vpc_cidr_block, 8, k + 52)]  # Intra subnets (/24 CIDR)

  # NAT Gateway and DNS settings
  enable_nat_gateway     = true                         # Enable NAT Gateway
  single_nat_gateway     = var.single_nat_gateway       # Singla NAT Gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az   # One NAT Gateway Per AZs
  enable_dns_hostnames   = true                         # Enable DNS hostnames

  # Flow Log settings
  enable_flow_log                      = true         # Enable VPC Flow Logs
  create_flow_log_cloudwatch_iam_role  = true         # Create IAM role for Flow Logs
  create_flow_log_cloudwatch_log_group = true         # Create CloudWatch log group for Flow Logs

  # Tags for public subnets
  public_subnet_tags = {
    "subnet_class"                    = "public"                    # Subnet class tag
    "karpenter.sh/discovery"          = var.eks_cluster_name        # Tag for Karpenter discovery
    "kubernetes.io/role/elb"          = 1                           # Tag for public ELB
  }

  # Tags for private subnets
  private_subnet_tags = {
    "subnet_class"                    = "private"                   # Subnet class tag
    "karpenter.sh/discovery"          = var.eks_cluster_name        # Tag for Karpenter discovery
    "kubernetes.io/role/internal-elb" = 1                           # Tag for internal ELB
  }

  # General tags
  tags = var.tags                       # Tags to be applied to the VPC
}