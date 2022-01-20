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
    zone = var.zone
    clust_name = google_container_cluster.terraform-builder-gcs-backend.name
    db_host = google_sql_database_instance.issuedb.first_ip_address
    db_user = google_sql_user.user.name
    db_pass = data.google_secret_manager_secret_version.db_pass.secret_data
    slack_wh = data.google_secret_manager_secret_version.slack_wh.secret_data
  })]

  set {
    name  = "clouds.kubernetes.credentialsId"
    value = var.project
}
} 

resource "kubernetes_namespace" "app" {
  metadata {

    name = "app"
  }
}
