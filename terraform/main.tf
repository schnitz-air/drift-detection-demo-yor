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
    Environment          = "Dev"
    yor_name             = "drift_demo"
    yor_trace            = "86eb5fa6-36b2-4d51-95e5-1c3fa394e11d"
    git_commit           = "fc712ea721ce601f923f01268134459f20e79723"
    git_file             = "terraform/main.tf"
    git_last_modified_at = "2026-04-06 16:49:51"
    git_last_modified_by = "amit.schnitzer@gmail.com"
    git_modifiers        = "amit.schnitzer"
    git_org              = "schnitz-air"
    git_repo             = "drift-detection-demo-yor"
  }
}

resource "aws_s3_bucket" "drift_bucket" {
  bucket        = "aschnitzer-drift-detection-yor"
  force_destroy = true

  tags = {
    Name                 = "aschnitzer-drift-detection-yor"
    Environment          = "demo"
    yor_name             = "drift_bucket"
    git_commit           = "670338fa6b5739b784bb7c49d1550283ce018753"
    git_file             = "terraform/main.tf"
    git_last_modified_at = "2026-04-06 19:42:48"
    git_last_modified_by = "amit.schnitzer@gmail.com"
    git_modifiers        = "amit.schnitzer"
    git_org              = "schnitz-air"
    git_repo             = "drift-detection-demo-yor"
    yor_trace            = "08f520e4-ba2f-49d2-b01f-ca3ac740f8d0"
  }
}

# Misconfiguration: Public access allowed (No Public Access Block)
# Misconfiguration: No encryption enabled
# Misconfiguration: No versioning enabled
# Misconfiguration: ACL set to public-read (if supported by account settings)
resource "aws_s3_bucket_ownership_controls" "drift_bucket_ownership" {
  bucket = aws_s3_bucket.drift_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "drift_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.drift_bucket_ownership]
  bucket     = aws_s3_bucket.drift_bucket.id
  acl        = "public-read"
}

resource "aws_s3_bucket_public_access_block" "drift_bucket_public_access" {
  bucket = aws_s3_bucket.drift_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
