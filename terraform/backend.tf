terraform {
  backend "s3" {
    bucket = "aschnitzer-terraform-state-files"
    key    = "drift-detection-demo-yor/terraform.tfstate"
    region = "us-east-1"
  }
}
