terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2"
    }
  }
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(google_container_cluster.terraform-builder-gcs-backend.master_auth.0.cluster_ca_certificate)
    host                   = "https://${google_container_cluster.terraform-builder-gcs-backend.endpoint}"
    token                  = data.google_client_config.default.access_token
  }
}

provider "kubernetes" {
  
  # load_config_file = false

  cluster_ca_certificate = base64decode(google_container_cluster.terraform-builder-gcs-backend.master_auth.0.cluster_ca_certificate)
  host                   = "https://${google_container_cluster.terraform-builder-gcs-backend.endpoint}"
  token                  = data.google_client_config.default.access_token
}
 
data "google_client_config" "default" {}

output "jenkins_link" {
  value = "https://${google_container_cluster.terraform-builder-gcs-backend.endpoint}:8080"
}