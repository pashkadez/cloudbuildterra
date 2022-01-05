resource "kubernetes_pod" "jenkins" {
  metadata {
    name = "jenkins"
    labels = {
      App = "jenkins"
    }
  }

  spec {
    container {
      image = "gcr.io/${var.project-name}/jenkins:latest"
      name  = "jenkins"

      port {
        container_port = 8080
      }
    }
  }
}


resource "kubernetes_service" "jenkins" {
  metadata {
    name = "jenkins"
  }
  spec {
    selector = {
      App = "${kubernetes_pod.jenkins.metadata.0.labels.App}"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
}
}


output "jenkins_ip" {
  value = kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].ip
}