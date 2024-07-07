module "eks_managed_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = var.cluster_name
  cluster_endpoint  = var.cluster_endpoint
  cluster_version   = var.cluster_version
  oidc_provider_arn = var.oidc_provider_arn

  # Wait for compute to be available
  create_delay_dependencies = [for group in var.managed_node_groups :
    group.node_group_arn if group.node_group_arn != null
  ]

  #---------------------------------------
  # Amazon EKS Managed Add-ons
  #---------------------------------------

  eks_addons = {
    coredns = {
      most_recent = true

      timeouts = {
        create = "25m"
        delete = "10m"
      }
      
      configuration_values = jsonencode({
        replicaCount = 2
        tolerations = [
        {
          key      = "app-priority",
          operator = "Equal",
          effect   = "NoSchedule",
          value    = "critical"
        }
        ]

        topologySpreadConstraints = [
          {
            maxSkew = 1
            topologyKey = "topology.kubernetes.io/zone"
            whenUnsatisfiable = "ScheduleAnyway"
            labelSelector = {
              matchLabels = {
                k8s-app: "kube-dns"
              }
            }
          }
        ]

        affinity = {
          nodeAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = {
              nodeSelectorTerms = [
              {
                matchExpressions = [
                  {
                    key = "node-priority"
                    operator = "In"
                    values = ["critical"]
                  },
                  {
                    key = "kubernetes.io/arch"
                    operator = "In"
                    values = ["amd64"]
                  }
                ]
              }]
            }
          }

          podAffinity = {
            requiredDuringSchedulingIgnoredDuringExecution = [{
                labelSelector = {
                  matchExpressions = [
                    {
                      key = "k8s-app"
                      operator = "NotIn"
                      values = ["kube-dns"]
                    }
                  ]
                }
                topologyKey = "kubernetes.io/hostname"
            }
            ]
          }

          podAntiAffinity = {
            preferredDuringSchedulingIgnoredDuringExecution = [{
              podAffinityTerm = {
                labelSelector = {
                  matchExpressions = [
                    {
                      key = "k8s-app"
                      operator = "In"
                      values = ["kube-dns"]
                    }
                  ]
                }
                topologyKey = "kubernetes.io/hostname"
              }
              weight = 100
              }
            ]
          }

        }
      })
    }

    vpc-cni = {
      most_recent = true
    }

    kube-proxy = {
      most_recent = true
    } 
  }
}