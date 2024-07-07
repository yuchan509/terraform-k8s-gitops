provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli2 to be installed locally where Terraform is executed
    args = [
      "eks", 
      "get-token", 
      "--cluster-name", 
      var.cluster_name
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.cluster.token

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli2 to be installed locally where Terraform is executed
      args = [
        "eks", 
        "get-token", 
        "--cluster-name", 
        var.cluster_name
      ]
    }
  }
}

# provider "kubectl" {
#   apply_retry_count      = 10
#   host                   = var.cluster_endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
#   load_config_file       = false
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }

module "k8s_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  #---------------------------------------
  # Kubernetes Add-ons
  #---------------------------------------

  #---------------------------------------
  # External DNS
  #---------------------------------------

  enable_external_dns = var.addons_enable.external_dns
  external_dns_route53_zone_arns = [
    "arn:aws:route53:::hostedzone/*",
  ]

  external_dns = {
    name          = "external-dns"
    chart_version = "${local.k8s_addons_version.external_dns}"
    repository    = "https://kubernetes-sigs.github.io/external-dns/"
    namespace     = "external-dns"
    values        = [templatefile("${path.module}/${local.k8s_utils_path}/external-dns/values.yaml", 
                    {
                      app_name = "external-dns"
                      eks_node_priority = "${local.eks_node_priority.critical}"
                    })]
  }

  #---------------------------------------
  # AWS LoadBalancer Controller
  #---------------------------------------

  enable_aws_load_balancer_controller = var.addons_enable.aws_load_balancer_controller
  aws_load_balancer_controller = {
    name           = "aws-load-balancer-controller"
    chart_version  = "${local.k8s_addons_version.aws_load_balancer_controller}"
    repository     = "https://aws.github.io/eks-charts/"
    namespace      = "kube-system"
    values         = [templatefile("${path.module}/${local.k8s_utils_path}/aws-load-balancer-controller/values.yaml",      
                    {
                      app_name = "aws-load-balancer-controller"
                      eks_node_priority = "${local.eks_node_priority.critical}"
                    })]
  }

  #---------------------------------------
  # EFS CSI Driver
  #---------------------------------------

  enable_aws_efs_csi_driver = var.addons_enable.aws_efs_csi_driver
  aws_efs_csi_driver = {
    name           = "aws-efs-csi-driver"
    chart_version  = "${local.k8s_addons_version.aws_efs_csi_driver}"
    repository     = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
    namespace      = "kube-system"
    values         = [templatefile("${path.module}/${local.k8s_utils_path}/aws-efs-csi-driver/values.yaml",   {
                      app_name = "aws-efs-csi-driver"
                      eks_node_priority = "${local.eks_node_priority.critical}"
                    })]
  }

  #---------------------------------------
  # Karpenter (Node AutoScaling)
  #---------------------------------------

  enable_karpenter = var.addons_enable.karpenter
  karpenter_enable_instance_profile_creation = true
  karpenter_enable_spot_termination          = true

  karpenter_node = {
    iam_role_use_name_prefix = false
  }

  karpenter = {
    name          = "karpenter"
    chart_version = "${local.k8s_addons_version.karpenter}"
    repository    = "oci://public.ecr.aws/karpenter"
    namespace     = "karpenter"
    values        = [templatefile("${path.module}/${local.k8s_utils_path}/karpenter/values.yaml", 
                    {
                      app_name = "karpenter"
                      eks_node_priority = "${local.eks_node_priority.critical}"
                    })]
  }

  #---------------------------------------
  # Metrics Server 
  #---------------------------------------
  
  enable_metrics_server = var.addons_enable.metrics_server
  metrics_server = {
    name          = "metrics-server"
    chart_version = "${local.k8s_addons_version.metrics_server}"
    repository    = "https://kubernetes-sigs.github.io/metrics-server/"
    namespace     = "kube-system"
    values        = [templatefile("${path.module}/${local.k8s_utils_path}/metrics-server/values.yaml", 
                    {
                      app_name = "metrics-server"
                      eks_node_priority = "${local.eks_node_priority.critical}"
                    })]
  }

  #---------------------------------------
  # FluentBit (Logging)
  #---------------------------------------

  enable_aws_for_fluentbit = var.addons_enable.aws_for_fluentbit
  # aws_for_fluentbit_cw_log_group = {
  #   create          = true
  #   use_name_prefix = true 
  #   name_prefix     = "${var.cluster_name}-logs-"
  #   retention       = 7
  # }

  # aws_for_fluentbit = {
  #   name          = "aws-for-fluent-bit"
  #   chart_version = "${local.k8s_addons_version.aws_for_fluentbit}"
  #   repository    = "https://aws.github.io/eks-charts"
  #   namespace     = "kube-system"
  #   values        = [templatefile("${path.module}/${local.k8s_utils_path}/fluentbit/values.yaml", 
  #                   {
  #                     app_name = "aws-for-fluent-bit"
  #                   })]
  # }

  #---------------------------------------
  # ArgoCD (CI/CD)
  #---------------------------------------
  enable_argocd = var.addons_enable.argocd
  argocd = {
    name          = "argocd"
    chart_version = "${local.k8s_addons_version.argocd}"
    repository    = "https://argoproj.github.io/argo-helm"
    namespace     = "argocd"
    values        = [templatefile("${path.module}/${local.k8s_utils_path}/argocd/values.yaml", 
                    {
                      eks_node_priority = "${local.eks_node_priority.important}"
                    })]
    }

  helm_releases = {

  #---------------------------------------
  # Nvidia Device Plugin
  #---------------------------------------

    nvidia-device-plugin = {
      count            = var.addons_enable.nvidia_device_plugin ? 1 : 0
      name             = "nvidia-device-plugin"
      chart            = "nvidia-device-plugin"
      chart_version    = "${local.k8s_addons_version.nvidia_device_plugin}"
      repository       = "https://nvidia.github.io/k8s-device-plugin"
      create_namespace = true
      namespace        = "nvidia-device-plugin"
      values           = [templatefile("${path.module}/${local.k8s_utils_path}/nvidia-device-plugin/values.yaml", 
                        {
                          app_name = "nvidia-device-plugin"
                        })]
    }

  #---------------------------------------
  # Kubernetes Event-driven Autoscaling
  #---------------------------------------

    keda = {
      count            = var.addons_enable.keda ? 1 : 0
      name             = "keda"
      chart            = "keda"
      chart_version    = "${local.k8s_addons_version.keda}"
      repository       = "https://kedacore.github.io/charts"
      create_namespace = true
      namespace        = "keda"
      values           = [templatefile("${path.module}/${local.k8s_utils_path}/keda/values.yaml", 
                        {
                          name_of_app_part = "keda-operator"
                          eks_node_priority = "${local.eks_node_priority.critical}"
                        })]
    }
  }

  tags = var.tags
}


#---------------------------------------
# Data on EKS Kubernetes Addons
#---------------------------------------

# module "eks_data_addons" {
#   source  = "aws-ia/eks-data-addons/aws"
#   version = "~> 1.0" 

#   oidc_provider_arn = var.oidc_provider_arn

#   #---------------------------------------
#   # Strimzi Kafka Add-on
#   #---------------------------------------

#   enable_strimzi_kafka_operator = true
#   strimzi_kafka_operator_helm_config = {
#     values = [templatefile("${path.module}/../../../k8s-utils/strimzi-kafka/values.yml", {
#       operating_system = "linux"
#       node_group_type  = "core"
#     })]
#   }
# }

# # ---------------------------------------
# # Install Kafka cluster
# # ---------------------------------------

resource "kubernetes_namespace" "kafka_namespace" {
  metadata {
    name = "kafka"
  }

  depends_on = [var.cluster_name]
}

# data "kubectl_path_documents" "kafka_cluster" {
#   pattern = "${path.module}/../../../k8s-utils/strimzi-kafka/kafka-cluster.yml"
# }

# resource "kubectl_manifest" "kafka_cluster" {
#   for_each  = toset(data.kubectl_path_documents.kafka_cluster.documents)
#   yaml_body = each.value

#   depends_on = [module.eks_data_addons]
# }
