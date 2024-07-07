# Retrieve information about the AWS account ID, account ARN, and the User ID of the caller
data "aws_caller_identity" "current" {}

# Define the EKS module
module "eks" {
  # Source and version of the EKS module
  source  = "terraform-aws-modules/eks/aws"
  version = "20.16.0"

  # General cluster settings
  cluster_name                   = var.cluster_name           # Name of the EKS cluster
  cluster_version                = var.cluster_version        # Version of the EKS cluster
  cluster_endpoint_public_access = true                       # Enable public access to the cluster endpoint

  # VPC and Subnet configurations
  vpc_id                   = var.eks_vpc_id                   # VPC ID where the cluster will be deployed
  subnet_ids               = var.eks_private_subnet_ids       # Subnets for EKS worker nodes
  control_plane_subnet_ids = var.eks_intra_subnets            # Subnets for the EKS control plane
 
  create_cluster_primary_security_group_tags = false          # Do not create primary security group tags for the cluster (default is true)
  enable_cluster_creator_admin_permissions   = true           # Grant admin permissions to the cluster creator
  
  # Default settings for EKS managed node groups
  eks_managed_node_group_defaults = {
    # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
    ami_type = "AL2_x86_64"             # Amazon Linux 2 AMI type for the nodes
    version  = var.cluster_version      # EKS cluster version for the nodes

    iam_role_additional_policies = {
      # Not required, but used in the example to access the nodes to inspect drivers and devices
      AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }

    ebs_optimized = true                # Enable EBS optimization for the nodes
    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"       # Device name for the EBS volume
        ebs = {
          volume_size = 100             # Size of the EBS volume in GiB
          volume_type = "gp3"           # Type of the EBS volume
          iops        = 3000            # IOPS for the EBS volume
          throughput  = 150             # Throughput for the EBS volume
          delete_on_termination = true  # Delete EBS volume on instance termination
        }
      }
    }
    tags = var.tags                     # Tags to be applied to the nodes
  }

  # Configuration for EKS managed node groups
  eks_managed_node_groups = {
    # This node group is for core addons such as CoreDNS, Kube-Proxy
    critical-app-node = {
      name            = "critical-app-node"        # Name of the node group
      use_name_prefix = false                      # Do not use a name prefix
      attach_cluster_primary_security_group = false

      instance_types  = ["t3.large",               # List of instance types for the node group
                        "t3a.large"]
                        
      capacity_type   = "ON_DEMAND"                # Use on-demand instances

      min_size        = 2                          # Minimum number of nodes in the node group
      max_size        = 3                          # Maximum number of nodes in the node group
      desired_size    = 2                          # Desired number of nodes in the node group

      subnet_ids      = var.eks_private_subnet_ids # Subnets for the node group

      labels = merge(var.tags, {                   # Labels to be applied to the nodes
        node-priority = "critical"                 # Custom label indicating the importance of the node group
      })

      taints = {
        app-priority = {
          key    = "app-priority"
          value  = "critical"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  # Tags to be applied to the EKS cluster
  tags = merge(var.tags, {
    "karpenter.sh/discovery" = var.cluster_name    # Tag for Karpenter discovery
  })
}