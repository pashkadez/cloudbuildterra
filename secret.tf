data "google_secret_manager_secret_version" "db_pass" {
  secret = "db_pass"
}
