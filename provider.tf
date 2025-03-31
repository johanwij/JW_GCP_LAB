# GCp Provider

provider "google" {
    project = var.project_id
    region  = var.region
    zone    = var.ZONE
}

resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  disable_on_destroy = false
}

provider "kubernetes" {
  config_path = "~/.kube/config" # Or your kubeconfig path
}