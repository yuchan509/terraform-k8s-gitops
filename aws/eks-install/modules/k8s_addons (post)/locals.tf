locals {
  k8s_utils_path = "../../../../k8s-utils"

  eks_node_priority = {
    critical      = "critical"
    important     = "important"
    moderate      = "moderate"
    minor         = "minor"
    insignificant = "insignificant"
  }
  
  k8s_addons_version = {
    external_dns                 = "1.14.5"
    aws_load_balancer_controller = "1.8.1"
    aws_efs_csi_driver           = "3.0.6"
    karpenter                    = "0.37.0"
    keda                         = "2.14.0"
    strimzi_kafka_operator       = "3.6"
    nvidia_device_plugin         = "0.15.1"
    metrics_server               = "3.12.0"
    aws_for_fluentbit            = "0.1.33"
    argocd                       = "7.3.4"
    kube-prometheus-stack        = "58.3.1"
  }
}