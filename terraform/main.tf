terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "aschnitzer-drift-detection-demo"
    key    = "terraform/state"
    region = "us-east-1"
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "aschnitzer-drift-detection-demo-yor-tags"

  tags = {
    Name                 = "drift-detection-demo-bucket"
    Environment          = "Dev"
    yor_name             = "demo_bucket"
    yor_trace            = "86eb5fa6-36b2-4d51-95e5-1c3fa394e11d"
    git_commit           = "85b80262410ceef37b2910d4f119ba4101d0b929"
    git_file             = "terraform/main.tf"
    git_last_modified_at = "2026-04-06 14:37:09"
    git_last_modified_by = "amit.schnitzer@gmail.com"
    git_modifiers        = "amit.schnitzer"
    git_org              = "schnitz-air"
    git_repo             = "drift-detection-demo-yor"
  }
}

resource "kubernetes_namespace" "demo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "demo"                         = "cortex-drift-detection-yor"
    }
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "drift-detection-demo-yor-nginx-deployment"
    namespace = kubernetes_namespace.demo.metadata[0].name
    labels = {
      app   = "nginx"
      owner = "schnitz"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "nginx"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx:1.25.3"
          name  = "nginx"

          port {
            container_port = 81
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "drift-detection-demo-yor-nginx-service"
    namespace = kubernetes_namespace.demo.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.nginx.metadata[0].labels.app
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "ClusterIP"
  }
}

# Trigger scan 2
