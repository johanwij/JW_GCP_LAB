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

output "cloud_sql_proxy_key_json" {
  value = google_service_account_key.cloud_sql_proxy_key.private_key
  sensitive = true
}

resource "local_file" "cloud_sql_proxy_key_file" {
  content  = google_service_account_key.cloud_sql_proxy_key.private_key
  filename = "key.json"
}
