# 1. Create the VPC Network_PROD
resource "google_compute_network" "vpc_prod" {
  project                 = var.project_id 
  name                    = var.vpc_name_prod
  auto_create_subnetworks = false # Important to set to false for custom subnets
  description             = "Production VPC"
}

# 2. Create the Subnets_PROD
resource "google_compute_subnetwork" "prod_wp_subnet" {
  project       = var.project_id
  name          = var.subnet_1_name_prod
  ip_cidr_range = var.subnet_1_cidr_prod
  network       = google_compute_network.vpc_prod.id
  region        = var.region
}

resource "google_compute_subnetwork" "prod_mgmt_subnet" {
  project       = var.project_id
  name          = var.subnet_2_name_prod
  ip_cidr_range = var.subnet_2_cidr_prod
  network       = google_compute_network.vpc_prod.id
  region        = var.region
}
