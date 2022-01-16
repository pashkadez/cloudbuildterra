resource "helm_release" "jenkins" {
  name                = "jenkins"
  repository          = "https://charts.jenkins.io"
  chart               = "jenkins"
  version             = "3.10.3"
  create_namespace    = "true"
  namespace           = "jenkins"

  # values = [templatefile("jenkins.yml", {
  #   region                = var.region
  #   storage               = "4Gi"
  # })]

  values = [templatefile("jenkins-values/values.yaml",{
    project = var.project
    bucket = var.bucket
    sa_cred = base64encode(data.google_secret_manager_secret_version.sa_cred.secret_data)
    db_pass = "${data.google_secret_manager_secret_version.db_pass.secret_data}"
  })]
}

# resource "kubernetes_stateful_set" "jenkins" {
#   metadata {
#     labels = {
#       app = "jenkins"
#     }

#     name = "jenkins"
#   }

#   spec {
#     pod_management_policy  = "Parallel"
#     replicas               = 1
#     revision_history_limit = 5

#     selector {
#       match_labels = {
#         k8s-app = "prometheus"
#       }
#     }

#     service_name = "prometheus"

#     template {
#       metadata {
#         labels = {
#           k8s-app = "prometheus"
#         }

#         annotations = {}
#       }

#       spec {
#         service_account_name = "prometheus"

#         init_container {
#           name              = "init-chown-data"
#           image             = "busybox:latest"
#           image_pull_policy = "IfNotPresent"
#           command           = ["chown", "-R", "65534:65534", "/data"]

#           volume_mount {
#             name       = "prometheus-data"
#             mount_path = "/data"
#             sub_path   = ""
#           }
#         }

#         container {
#           name              = "prometheus-server-configmap-reload"
#           image             = "jimmidyson/configmap-reload:v0.1"
#           image_pull_policy = "IfNotPresent"

#           args = [
#             "--volume-dir=/etc/config",
#             "--webhook-url=http://localhost:9090/-/reload",
#           ]

#           volume_mount {
#             name       = "config-volume"
#             mount_path = "/etc/config"
#             read_only  = true
#           }

#           resources {
#             limits = {
#               cpu    = "10m"
#               memory = "10Mi"
#             }

#             requests = {
#               cpu    = "10m"
#               memory = "10Mi"
#             }
#           }
#         }

#         container {
#           name              = "prometheus-server"
#           image             = "prom/prometheus:v2.2.1"
#           image_pull_policy = "IfNotPresent"

#           args = [
#             "--config.file=/etc/config/prometheus.yml",
#             "--storage.tsdb.path=/data",
#             "--web.console.libraries=/etc/prometheus/console_libraries",
#             "--web.console.templates=/etc/prometheus/consoles",
#             "--web.enable-lifecycle",
#           ]

#           port {
#             container_port = 9090
#           }

#           resources {
#             limits = {
#               cpu    = "200m"
#               memory = "1000Mi"
#             }

#             requests = {
#               cpu    = "200m"
#               memory = "1000Mi"
#             }
#           }

#           volume_mount {
#             name       = "config-volume"
#             mount_path = "/etc/config"
#           }

#           volume_mount {
#             name       = "prometheus-data"
#             mount_path = "/data"
#             sub_path   = ""
#           }

#           readiness_probe {
#             http_get {
#               path = "/-/ready"
#               port = 9090
#             }

#             initial_delay_seconds = 30
#             timeout_seconds       = 30
#           }

#           liveness_probe {
#             http_get {
#               path   = "/-/healthy"
#               port   = 9090
#               scheme = "HTTPS"
#             }

#             initial_delay_seconds = 30
#             timeout_seconds       = 30
#           }
#         }

#         termination_grace_period_seconds = 300

#         volume {
#           name = "config-volume"

#           config_map {
#             name = "prometheus-config"
#           }
#         }
#       }
#     }

#     update_strategy {
#       type = "RollingUpdate"

#       rolling_update {
#         partition = 1
#       }
#     }

#     volume_claim_template {
#       metadata {
#         name = "prometheus-data"
#       }

#       spec {
#         access_modes       = ["ReadWriteOnce"]
#         storage_class_name = "standard"

#         resources {
#           requests = {
#             storage = "16Gi"
#           }
#         }
#       }
#     }
#   }
# }

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