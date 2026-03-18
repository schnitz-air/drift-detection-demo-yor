terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
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

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-deployment-yor"
    namespace = var.namespace
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
    name      = "nginx-service-yor"
    namespace = var.namespace
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
