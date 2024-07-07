terraform {
    backend "s3" {
      bucket         = "monitor-eks-cluster-tfstate"
      key            = "State/k8s_Addons/terraform.tfstate"
      region         = "ap-northeast-2"
      profile        = "root"
      dynamodb_table = "monitor-eks-cluster-TerraformStateLock"
      encrypt        = true
    }
}