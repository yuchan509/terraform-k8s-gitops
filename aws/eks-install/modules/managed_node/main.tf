module "eks_managed_node_group" {
  source = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"

  use_name_prefix      = false
  name                 = var.node_group_name
  cluster_name         = var.eks_cluster_name
  cluster_version      = var.cluster_version
  cluster_service_cidr = var.cluster_vpc_cidr

  subnet_ids                        = data.aws_subnets.private_subnets.ids
  vpc_security_group_ids            = [data.aws_security_group.node_group.id]                              
  # cluster_primary_security_group_id = data.aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id 
  
  iam_role_additional_policies = var.iam_role_additional_policies

  ami_type = var.ami_type

  block_device_mappings = {
    xvda = {
      device_name = "/dev/xvda"
      ebs = {
        volume_size          = var.block_device_volume_size
        volume_type          = var.block_device_volume_type
        iops                 = var.block_device_iops
        throughput           = var.block_device_throughput
        delete_on_termination = true
      }
    }
  }

  min_size       = var.min_size
  max_size       = var.max_size
  desired_size   = var.desired_size

  instance_types = var.instance_types
  capacity_type  = var.capacity_type

  labels         = var.labels
  taints         = var.taints

  tags = var.tags
}