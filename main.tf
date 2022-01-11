provider "google" {
  project     = "${var.project-name}"
  region      = "${var.region}"
}


resource "google_container_cluster" "terraform-builder-gcs-backend" {
  name               = "terraform-built"
  location           = "${var.zone}"
  initial_node_count = "1"

  node_config {
    machine_type = "${var.machine_type}"
    disk_size_gb  = "100"
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
#   #   environment = "dev"
#   # }
# }