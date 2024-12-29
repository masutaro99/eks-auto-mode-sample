provider "aws" {
  region = "ap-northeast-1"
}

terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket = "tfstate-bucket-maskenpa"
    key    = "auto-mode/common-environment.tfstate"
    region = "ap-northeast-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.82"
    }
  }
}