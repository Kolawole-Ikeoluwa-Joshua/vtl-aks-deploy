provider "kubernetes" {
  host                   = var.host
  client_certificate     = var.client_certificate
  client_key             = var.client_key
  cluster_ca_certificate = var.cluster_ca_certificate
}


resource "kubernetes_deployment" "vtl-nginx" {
  metadata {
    name = "vtl-nginx-dev"
    labels = {
      test = "vtl-nginx-dev"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        test = "vtl-nginx-dev"
      }
    }

    template {
      metadata {
        labels = {
          test = "vtl-nginx-dev"
        }
      }

      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

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

          liveness_probe {
            http_get {
              path = "/nginx_status"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "vtl-nginx-svc" {
  metadata {
    name = "vtl-nginx-dev-svc"
  }
  spec {
    selector = {
      test = "vtl-nginx-dev"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}