data "google_compute_subnetwork" "dev_mgmt_subnet" {
  name    = "griffin-dev-mgmt"
  region  = var.region             
  project = var.project_id         
}

data "google_compute_subnetwork" "prod_mgmt_subnet" {
  name    = "griffin-prod-mgmt"
  region  = var.region             
  project = var.project_id         
}

