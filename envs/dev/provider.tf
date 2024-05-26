terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      aws    = "4.67.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
