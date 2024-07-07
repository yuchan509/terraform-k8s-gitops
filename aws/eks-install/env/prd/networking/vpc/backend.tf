terraform {
    backend "s3" {
      bucket         = "prd-eks-cluster-tfstate"
      key            = "State/VPC/terraform.tfstate"
      region         = "ap-northeast-2"
      profile        = "root"
      dynamodb_table = "prd-eks-cluster-TerraformStateLock"
      encrypt        = true
    }
}