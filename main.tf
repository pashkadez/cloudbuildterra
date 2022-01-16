provider "google" {
  project     = "${var.project}"
  region      = "${var.region}"
}


resource "google_container_cluster" "terraform-builder-gcs-backend" {
  name               = "terraform-built"
  location           = "${var.zone}"
  initial_node_count = "1"

  node_config {
    machine_type = "${var.machine_type}"
    disk_size_gb  = "100"
    image_type = "ubuntu"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      reason = "terraform-builder"
    }

    tags = ["node"]
  }
}

# resource "google_compute_disk" "jenkins" {
#   name  = "jenkins-pd"
#   # type  = "pd-ssd"
#   zone  = var.zone
#   size  = "10"
#   # image = "debian-9-stretch-v20200805"
#   # labels = {
#   #   App = "jenkins"
#   # }
# }

# data "helm_template" "jenkins" {
#   name                = "jenkins"
#   repository          = "https://charts.jenkins.io"
#   chart               = "jenkins"
#   version             = "3.10.3"
#   create_namespace    = "true"
# }

# resource "local_file" "jenkins_manifests" {
#   for_each = data.helm_template.jenkins.manifests

#   filename = "./${each.key}"
#   content  = each.value
# }

# output "jenkins_instance_manifest_bundle" {
#   value = data.helm_template.jenkins.manifest_bundle
# }

# output "jenkins_instance_manifests" {
#   value = data.helm_template.jenkins.manifests
# }

# output "jenkins_instance_notes" {
#   value = data.helm_template.jenkins.notes
# }