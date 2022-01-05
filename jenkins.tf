# resource "helm_release" "jenkins" {
#   name                = "jenkins"
#   repository          = "https://charts.jenkins.io"
#   chart               = "jenkins"
#   version             = "3.9.4"
#   create_namespace    = "true"
#   namespace           = "jenkins-ns"
# 
# resource "helm_release" "jenkins" {
#   name                = "jenkins"
#   repository          = "https://gcr.io/pasha-testproject-12345/jenkins"
#   chart               = "${path.module}/jenkins/Chart.yaml"
#   # version             = "3.9.4"
#   create_namespace    = "true"
#   namespace           = "jenkins-ns"

#   values = [
#     file("${path.module}/jenkins-values/values.yaml"),
#   ]

# }


resource "kubernetes_deployment" "jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      run = "jenkins"
    }
  }

  spec {
    replicas = 1
    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge       = 1
        max_unavailable = 0
      }
    }

    selector {
      match_labels = {
        run = "jenkins"
      }
    }

    template {
      metadata {
        name = "jenkins"
        labels = {
          run = "jenkins"
        }
      }

      spec {
        container {
          image = "gcr.io/${var.project-name}/jenkins:jcasc"
          name  = "jenkins"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "jenkins" {
  metadata {
    name                = kubernetes_deployment.jenkins.metadata[0].name
    # namespace           = "jenkins-ns"
  }
  spec {
    selector = {
      app = kubernetes_deployment.jenkins.metadata[0].name
    }
    session_affinity    = "ClientIP"
    port {
      port              = 8080
      target_port       = 8080
    }

    type = "LoadBalancer"
  }
}
output "jenkins_ip" {
  value = kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].ip
}