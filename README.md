# Drift Detection Demo - VPC

This repository demonstrates drift detection using a simple AWS VPC setup.

## Infrastructure
- **VPC Name**: Drift-Demo-YOR
- **CIDR**: 192.168.1.0/24
- **Tooling**: Terraform
- **State Management**: S3 Backend (`drift-detection-demo-terraform-state`)

## CI/CD
GitHub Actions automatically plans and applies changes pushed to the `main` branch.
