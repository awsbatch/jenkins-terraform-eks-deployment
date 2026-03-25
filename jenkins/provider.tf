terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  backend "s3" {
    bucket = "vfirst-state-file-bkt"
    key    = "eks"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}