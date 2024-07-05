terraform {
  required_version = ">= 1.8.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.1.0"
    }
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = "administrator"
}
