 # 1. Create Cloud SQL instance
resource "google_sql_database_instance" "db_instance" {
  project	   = var.project_id
  name             = var.db_instance_name
  region           = var.region
  database_version = "MYSQL_8_0"
  root_password = var.db_root_password
  settings {
    tier = "db-f1-micro" # Or a suitable tier
    ip_configuration {
      authorized_networks {
        name  = "Allow public access" #Replace with better name.
        value = "0.0.0.0/0" # Consider more restrictive IP ranges for security.
      }
    }
  }
}

# 2. Create the Wordpress database
resource "google_sql_database" "wordpress_db" {
  project  = var.project_id
  name     = "wordpress"
  instance = google_sql_database_instance.db_instance.name
}

# 3. Create the wordpress user and grant privileges
resource "google_sql_user" "wp_user" {
  project  = var.project_id
  name     = "wp_user"
  instance = google_sql_database_instance.db_instance.name
  password = var.wp_user_password
  host     = "%" # Allows connections from any host; restrict as needed
}

resource "google_sql_user" "grant_wp_user" {
  project  = var.project_id
  name     = "wp_user"
  instance = google_sql_database_instance.db_instance.name
  host     = "%"
  password = var.wp_user_password
  }



