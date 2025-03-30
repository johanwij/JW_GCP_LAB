# 1. Prepare the Kubernetes cluster. Update wp-env.yaml
resource "local_file" "wp_env_yaml" {
  content = templatefile("wp-env.yaml.tftpl", {
    wp_user_password = var.wp_user_password
  })
  filename = "wp-k8s/wp-env.yaml"
}

# 2. Create kubernetes_secret
resource "kubernetes_secret" "db_user" {
  metadata {
    name = "db-user"
  }

  type = "Opaque"

  data = {
    username = base64encode("wp_user")
    password = base64encode(var.wp_user_password)
  }
}

# 3. Create service account for cloud sql proxy
resource "google_service_account" "cloud_sql_proxy_sa" {
  account_id   = "cloud-sql-proxy"
  display_name = "Cloud SQL Proxy Service Account"
}

# 4. create cloud sql proxy service account key.
resource "google_service_account_key" "cloud_sql_proxy_key" {
  service_account_id = google_service_account.cloud_sql_proxy_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# 5. output the key file contents. This can be used to write the json key file.
output "cloud_sql_proxy_key_json" {
  value = google_service_account_key.cloud_sql_proxy_key.private_key
  sensitive = true
}

resource "local_file" "cloud_sql_proxy_key_file" {
  content  = google_service_account_key.cloud_sql_proxy_key.private_key
  filename = "key.json"
}
