# 1. Create the bastion host with two network interfaces

resource "google_compute_instance" "bastion" {
  project      = var.project_id  
  name         = var.bastion_name
  machine_type = var.bastion_machine_type
  zone         = var.ZONE

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Or your desired image
    }
  }

  network_interface {
    network    = var.vpc_name_dev
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }

  network_interface {
    network    = var.vpc_name_prod
    subnetwork = google_compute_subnetwork.subnet.id
    access_config {}
  }
}

# 2. Firewall rule for development VPC
resource "google_compute_firewall" "allow_ssh_dev" {
  project      = var.project_id
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
  project      = var.project_id
  name    = var.firewall_rule_name_prod
  network = var.vpc_name_prod
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = var.ssh_source_range
  target_tags   = ["ssh", var.bastion_name]
}
