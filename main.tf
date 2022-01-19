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
