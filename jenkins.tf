
resource "helm_release" "jenkins" {
  name                = "jenkins"
  repository          = "https://charts.jenkins.io"
  chart               = "jenkins"
  version             = "3.9.4"
  create_namespace    = "true"
  namespace           = "jenkins"
    values = [
    file("${path.module}/jenkins-values/values.yaml"),
  ]
}

# resource "kubernetes_deployment" "jenkins" {
#   metadata {
#     name = "jenkins"
#     namespace = "jenkins"
#     labels = {
#       App = "jenkins"
#     }
#   }
#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         App = "jenkins"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           App = "jenkins"
#         }
#       }

#       spec {
#         container {
#           image = "gcr.io/${var.project-name}/jenkins:latest"
#           name  = "jenkins"

#           resources {
#             limits = {
#               cpu    = "1"
#               memory = "1024Mi"
#             }
#             requests = {
#               cpu    = "0.5"
#               memory = "512Mi"
#             }
#           }
#           port {
#             container_port = 8080
#           }
#           port {
#             container_port = 50000
#           }
#         }
#       }
#     }
#   }
# }


# resource "kubernetes_service" "jenkins" {
#   metadata {
#     name = "jenkins"
#     namespace = "jenkins"
#   }
#   spec {
#     selector = {
#       App = "${kubernetes_deployment.jenkins.metadata.0.labels.App}"
#     }
#     port {
#       port        = 80
#       target_port = 8080
#     }
#     type = "LoadBalancer"
# }
# }

resource "kubernetes_namespace" "app" {
  metadata {

    name = "app"
  }
}

# resource "kubernetes_namespace" "jenkins" {
#   metadata {

#     name = "jenkins"
#   }
# }

# resource "kubernetes_persistent_volume_claim" "jenkins" {
#   metadata {
#     name = "jenkins-pvc"
#   }
#   spec {
#     access_modes = ["ReadWriteMany"]
#     resources {
#       requests = {
#         storage = "10Gi"
#       }
#     }
#     volume_name = "${kubernetes_persistent_volume.jenkins.metadata.0.name}"
#   }
# }

# resource "kubernetes_persistent_volume" "jenkins" {
#   metadata {
#     name = "jenkins"
#   }
#   spec {
#     capacity = {
#       storage = "10Gi"
#     }
#     access_modes = ["ReadWriteMany"]
#     persistent_volume_source {
#       gce_persistent_disk {
#         pd_name = "jenkins-pd"
#       }
#     }
#   }
# }

# output "jenkins_ip" {
#   value = kubernetes_service.jenkins.status[0].load_balancer[0].ingress[0].ip
# }