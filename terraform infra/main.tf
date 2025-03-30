# ****  Task 1 ****

# 1. Create the VPC Network_DEV
resource "google_compute_network" "vpc_dev" {
  name                    = var.vpc_name_dev
  auto_create_subnetworks = false # Important to set to false for custom subnets
  description             = "Development VPC"
}

# 2. Create the Subnets_DEV
resource "google_compute_subnetwork" "subnet_1_dev" {
  name          = var.subnet_1_name_dev
  ip_cidr_range = var.subnet_1_cidr_dev
  network       = google_compute_network.vpc_dev.id
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_2_dev" {
  name          = var.subnet_2_name_dev
  ip_cidr_range = var.subnet_2_cidr_dev
  network       = google_compute_network.vpc_dev.id
  region        = var.region
}

# ****  Task 2 ****

# 1. Create the VPC Network_PROD
resource "google_compute_network" "vpc_prod" {
  name                    = var.vpc_name_prod
  auto_create_subnetworks = false # Important to set to false for custom subnets
  description             = "Production VPC"
}

# 2. Create the Subnets_PROD
resource "google_compute_subnetwork" "subnet_1_prod" {
  name          = var.subnet_1_name_prod
  ip_cidr_range = var.subnet_1_cidr_prod
  network       = google_compute_network.vpc_prod.id
  region        = var.region
}

resource "google_compute_subnetwork" "subnet_2_prod" {
  name          = var.subnet_2_name_prod
  ip_cidr_range = var.subnet_2_cidr_prod
  network       = google_compute_network.vpc_prod.id
  region        = var.region
}

# ****  Task 3 ****

# 1. Create the bastion host with two network interfaces

resource "google_compute_instance" "bastion" {
  name         = var.bastion_name
  machine_type = var.bastion_machine_type
  zone         = var.ZONE

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Or your desired image
    }
  }

  network_interface {
    network    = var.network_1
    subnetwork = var.subnetwork_1
    access_config {
      // Assign an external IP to the bastion host for SSH access
    }
  }

  network_interface {
    network    = var.network_2
    subnetwork = var.subnetwork_2
  }
}

# 2. Firewall rule for development VPC
resource "google_compute_firewall" "allow_ssh_dev" {
  name    = var.firewall_rule_name_dev
  network = var.vpc_name_dev
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.ssh_source_range
  target_tags   = ["ssh", var.bastion_name]
}

# 3. Firewall rule for production VPC
resource "google_compute_firewall" "allow_ssh_prod" {
  name    = var.firewall_rule_name_prod
  network = var.vpc_name_prod
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.ssh_source_range
  target_tags   = ["ssh", var.bastion_name]
}

# ****  Task 4 ****

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

# ****  Task 5 ****

# 1. Create Kubernetes cluster
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.ZONE
  network  = var.network
  subnetwork = var.subnetwork
  initial_node_count = var.num_nodes

  node_config {
    machine_type = var.machine_type
  }
}

# ****  Task 6 ****

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

# ****  Task 7 ****
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

