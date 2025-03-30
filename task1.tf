# 1. Create the VPC Network_DEV
resource "google_compute_network" "vpc_dev" {
  project                 = var.project_id
  name                    = var.vpc_name_dev
  auto_create_subnetworks = false # Important to set to false for custom subnets to allow precise control over IP ranges and better isolation of resources.
  description             = "Development VPC"
}

# 2. Create the Subnets_DEV
resource "google_compute_subnetwork" "dev_wp_subnet" {
  project       = var.project_id
  name          = var.subnet_1_name_dev
  ip_cidr_range = var.subnet_1_cidr_dev
  network       = google_compute_network.vpc_dev.id
  region        = var.region
}

resource "google_compute_subnetwork" "dev_mgmt_subnet" {
  project       = var.project_id
  name          = var.subnet_2_name_dev
  ip_cidr_range = var.subnet_2_cidr_dev
  network       = google_compute_network.vpc_dev.id
  region        = var.region
}
