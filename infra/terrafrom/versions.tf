terraform {
  required_version = ">=1.3.9"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.64.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "aws" {
  region = var.aws_region
}