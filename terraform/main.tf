terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
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
    Name                 = "Drift-Demo-YOR"
    git_commit           = "eee23bcadf2753efa514c19158f354419a59d7cc"
    git_file             = "terraform/main.tf"
    git_last_modified_at = "2026-04-06 16:49:51"
    git_last_modified_by = "amit.schnitzer@gmail.com"
    git_modifiers        = "amit.schnitzer"
    git_org              = "schnitz-air"
    git_repo             = "drift-detection-demo-yor"
    yor_name             = "drift_demo"
    yor_trace            = "26fbee82-4016-4028-85c1-55566263fef0"
  }
}
