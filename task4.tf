 # 1. Create Cloud SQL instance
resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance_name
  region           = var.region
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro" # Or a suitable tier
    ip_configuration {
      authorized_networks {
        name = "bastion-host"
        value = google_compute_instance.bastion.network_interface[0].network_ip
      }
      ipv4_enabled = true # Enable public IP if needed
    }
  }
  root_password = var.db_root_password
}

# 2. Create the Wordpress database
resource "google_sql_database" "wordpress_db" {
  name     = "wordpress"
  instance = google_sql_database_instance.db_instance.name
}

# 3. Create the wordpress user and grant privileges
resource "google_sql_user" "wp_user" {
  name     = "wp_user"
  instance = google_sql_database_instance.db_instance.name
  password = var.wp_user_password
  host     = "%" # Allows connections from any host; restrict as needed
}

resource "google_sql_user" "grant_wp_user" {
  name = "wp_user"
  instance = google_sql_database_instance.db_instance.name
  host = "%"
  type = "CLOUD_SQL_USER"
  password = var.wp_user_password
  deletion_policy = "NO_DELETE_PARENT"
  depends_on = [google_sql_user.wp_user, google_sql_database.wordpress_db]
  dynamic "sql_server_user_options" {
    for_each = [1]
    content {
      default_auth_plugin = "mysql_native_password"
      grant_all_privileges = true
      grant_option = false
      database = "wordpress"
    }
  }
}
