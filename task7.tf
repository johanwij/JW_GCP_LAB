resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance_name
  region           = "us-central1" # Or your instance's region.
  database_version = "MYSQL_8_0"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
        ipv4_enabled = true # Enable public IP if needed
        authorized_networks {
            name  = "bastion-host"
            value = google_compute_instance.bastion.network_interface[0].network_ip
        }
    }
  }
}

resource "google_service_account" "cloud_sql_proxy_sa" {
  account_id   = "cloud-sql-proxy"
  display_name = "Cloud SQL Proxy Service Account"
  project = var.project_id
}

resource "google_service_account_key" "cloud_sql_proxy_key" {
  service_account_id = google_service_account.cloud_sql_proxy_sa.name
  public_key_type    = "TYPE_JSON"
}

resource "kubernetes_secret" "cloudsql_instance_credentials" {
  metadata {
    name = "cloudsql-instance-credentials"
  }

  type = "Opaque"

  data = {
    "key.json" = base64encode(google_service_account_key.cloud_sql_proxy_key.private_key)
  }
}

resource "local_file" "wp_deployment_yaml" {
  content = templatefile("wp-deployment.yaml.tftpl", {
    db_instance_connection_name = google_sql_database_instance.db_instance.connection_name
  })
  filename = "wp-deployment.yaml"
}

resource "kubernetes_manifest" "wp_deployment" {
  manifest = file("wp-deployment.yaml")
}

resource "kubernetes_manifest" "wp_service" {
  manifest = file("wp-service.yaml")
}

