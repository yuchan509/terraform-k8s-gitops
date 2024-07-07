variable "cluster_name" {
  description = "AWS EKS Cluster Name"
  type        = string
}

variable "cluster_version" {
  description = "EKS Cluster version"
  type        = string
}

variable "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider ARN"
  type        = string
}

variable "addons_enable" {
  description = "Enable or disable Kubernetes add-ons"
  type = object({
    external_dns                  = bool
    aws_load_balancer_controller  = bool
    aws_efs_csi_driver            = bool
    karpenter                     = bool
    metrics_server                = bool
    aws_for_fluentbit             = bool
    argocd                        = bool
    nvidia_device_plugin          = bool
    keda                          = bool
  })

  default = {
    external_dns                  = false
    aws_load_balancer_controller  = false
    aws_efs_csi_driver            = false
    karpenter                     = false
    metrics_server                = false
    argocd                        = false
    aws_for_fluentbit             = false
    nvidia_device_plugin          = false
    keda                          = false
  }
}

variable "tags" {
  description = "AWS EKS Tags"
  type        = map(string)
}