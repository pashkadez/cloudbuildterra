
resource "kubernetes_secret" "kubeconfig" {
    metadata {
    namespace = "jenkins"
    name = "kubeconfig"
    }
  data = {
    config = "${local.config}",
    "sa-private-key.json" = "${data.google_secret_manager_secret_version.sa_cred.secret_data}"
    }
    depends_on = [
        local.config,
    ]
}

locals {
    sensitive = true
    config = <<-EOT
apiVersion: v1
kind: Config
clusters:
- name: ${google_container_cluster.terraform-builder-gcs-backend.name}
  cluster:
    server: https://${google_container_cluster.terraform-builder-gcs-backend.endpoint}
    certificate-authority-data: ${google_container_cluster.terraform-builder-gcs-backend.master_auth.0.cluster_ca_certificate}
users:
- name: ${google_container_cluster.terraform-builder-gcs-backend.name}
  user:
    auth-provider:
      name: gcp
contexts:
- context:
    cluster: ${google_container_cluster.terraform-builder-gcs-backend.name}
    user: ${google_container_cluster.terraform-builder-gcs-backend.name}
  name: ${google_container_cluster.terraform-builder-gcs-backend.name}
current-context: ${google_container_cluster.terraform-builder-gcs-backend.name}
  EOT
}

# resource "local_file" "config" {
#     content  = "${local.config}"
#     filename = "${path.module}/config"
# }