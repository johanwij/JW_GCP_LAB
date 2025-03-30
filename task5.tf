# 1. Create Kubernetes cluster
resource "google_container_cluster" "gke_cluster" {
  name     = var.cluster_name
  location = var.ZONE
  network  = var.vpc_name_dev
  subnetwork = var.subnet_1_name_dev
  initial_node_count = var.num_nodes

  node_config {
    machine_type = var.machine_type
  }
}
