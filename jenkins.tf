resource "helm_release" "jenkins" {
  name                = "jenkins"
  repository          = "https://charts.jenkins.io"
  chart               = "jenkins"
  version             = "3.9.4"
  create_namespace    = "true"
  namespace           = "jenkins-ns"

# resource "helm_release" "jenkins" {
#   name                = "jenkins"
#   repository          = "https://gcr.io/pasha-testproject-12345/jenkins"
#   chart               = "${path.module}/jenkins/Chart.yaml"
#   # version             = "3.9.4"
#   create_namespace    = "true"
#   namespace           = "jenkins-ns"

  values = [
    file("${path.module}/jenkins-values/values.yaml"),
  ]

}

# resource "kubernetes_service" "jenkins" {
#   metadata {
#     name                = "jenkins-serv"
#     namespace           = "jenkins-ns"
#   }
#   spec {
#     selector = {
#       app = helm_release.jenkins.name
#     }
#     session_affinity    = "ClientIP"
#     port {
#       port              = 80
#       target_port       = 8080
#     }

#     type = "LoadBalancer"
#   }
# }

# output "jenkins_ip" {
#   jenkins_ip = kubernetes_service.jenkins.
# }