resource "helm_release" "jenkins" {
  name                = "jenkins"
  repository          = "https://charts.jenkins.io"
  chart               = "jenkins"
  version             = "3.10.3"
  create_namespace    = "true"
  namespace           = "jenkins"

  values = [templatefile("jenkins-values/values.yaml",{
    project = var.project
    bucket = var.bucket
    db_pass = "${data.google_secret_manager_secret_version.db_pass.secret_data}"
    zone = var.zone
    clust_name = google_container_cluster.terraform-builder-gcs-backend.name
  })]
} 

resource "kubernetes_namespace" "app" {
  metadata {

    name = "app"
  }
}

