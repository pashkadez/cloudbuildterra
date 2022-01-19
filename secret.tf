data "google_secret_manager_secret_version" "db_pass" {
  secret = "db_pass"
}

data "google_secret_manager_secret_version" "sa_cred" {
  secret = "sa_cred"
}

data "google_secret_manager_secret_version" "slack_wh" {
  secret = "slack_wh"
}