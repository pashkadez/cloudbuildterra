resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = "jenkins"
    labels = {
      App = "jenkins"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        App = "jenkins"
      }
    }

    template {
      metadata {
        labels = {
          App = "jenkins"
        }
      }

      spec {
        container {
          image = "gcr.io/${var.project-name}/jenkins:latest"
          name  = "jenkins"

          resources {
            limits = {
              cpu    = "1"
              memory = "1024Mi"
            }
            requests = {
              cpu    = "0.5"
              memory = "512Mi"
            }
          }
          port {
            container_port = 8080
          }
          port {
            container_port = 50000
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
    namespace = "jenkins"
  }
  spec {
    selector = {
      App = "${kubernetes_deployment.jenkins.metadata.0.labels.App}"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
}
}

resource "kubernetes_namespace" "app" {
  metadata {

    name = "app"
  }
}

resource "kubernetes_namespace" "jenkins" {
  metadata {

    name = "jenkins"
  }
}

output "jenkins_ip" {
  value = kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].ip
}