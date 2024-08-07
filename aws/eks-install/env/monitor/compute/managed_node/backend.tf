terraform {
    backend "s3" {
      bucket         = "monitor-eks-cluster-tfstate"
      key            = "State/MNG_NODE/terraform.tfstate"
      region         = "ap-northeast-2"
      profile        = "root"
      dynamodb_table = "monitor-eks-cluster-TerraformStateLock"
      encrypt        = true
    }
}