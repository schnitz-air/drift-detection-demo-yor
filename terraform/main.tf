terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "drift-detection-demo-terraform-state"
    key    = "terraform/vpc-state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "drift_demo" {
  cidr_block           = "192.168.1.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "Drift-Demo-YOR"
  }
}
