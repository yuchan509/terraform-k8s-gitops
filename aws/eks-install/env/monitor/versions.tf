provider "aws" {
  profile = var.profile
  region  = var.region
}

terraform {
  required_version = ">= 1.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.1"  
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.31.0" 
    }
  }

  backend "s3" {
    bucket         = "monitor-eks-cluster-tfstate"
    key            = "State/EKS/terraform.tfstate"
    region         = "ap-northeast-2"
    profile        = "root"
    dynamodb_table = "monitor-eks-cluster-TerraformStateLock"
    encrypt        = true
  }
}