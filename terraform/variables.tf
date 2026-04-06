variable "region" {
  description = "AWS region"
  type        = "string"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = "string"
  default     = "192.168.1.0/24"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = "string"
  default     = "Drift-Demo-YOR"
}
