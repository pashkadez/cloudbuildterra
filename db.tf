# resource "google_sql_database" "database" {
#   name     = "mydatabase"
#   instance = google_sql_database_instance.instance.name
# }

# resource "google_sql_database_instance" "instance" {
#   name             = "postgres"
#   region           = var.region
#   database_version = "POSTGRES_12"
#   settings {
#         tier = "db-f1-micro"
#         ip_configuration {
#                 ipv4_enabled = true
#                 # require_ssl = true
                
#                 authorized_networks {
#                     name = "The Network"
#                     value = "0.0.0.0/0"
#                 }
#                 # authorized_networks  {
#                 #     name = "${google_compute_network.name}"
#                 #     value = "${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip}/24"
#                 # }
#         }   
#     }
  
#   deletion_protection  = "false"
# }

# resource "google_sql_user" "users" {
#     name = "user"
#     instance = google_sql_database_instance.instance.name
#     host = "%"
#     password = "${data.google_secret_manager_secret_version.db_pass.secret_data}"
# }

# output "gcp_mysql_ip" {
#   value = "${google_sql_database_instance.instance.first_ip_address}"
# }
