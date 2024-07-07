data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
  depends_on = [var.cluster_name]
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
  depends_on = [var.cluster_name]
}

# data "kubectl_path_documents" "kafka_cluster" {
#   pattern = "${path.module}/../../../../k8s-utils/strimzi-kafka/kafka-cluster.yaml"
# }