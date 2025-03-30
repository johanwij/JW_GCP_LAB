resource "google_compute_network" "vpc_dev" {
  project                 = var.project_id
  name                    = var.vpc_name_dev
  auto_create_subnetworks = false # Important to set to false for custom subnets to allow precise control over IP ranges and better isolation of resources.
  description             = "Development VPC"
}

resource "google_compute_subnetwork" "griffin-dev-wp_subnet" {
  project       = var.project_id
  name          = var.subnet_1_name_dev
  ip_cidr_range = var.subnet_1_cidr_dev
  network       = google_compute_network.vpc_dev.id
  region        = var.region
}

resource "google_compute_subnetwork" "griffin-dev-mgmt_subnet" {
  project       = var.project_id
  name          = var.subnet_2_name_dev
  ip_cidr_range = var.subnet_2_cidr_dev
  network       = google_compute_network.vpc_dev.id
  region        = var.region
}

data "google_compute_subnetwork" "griffin-dev-mgmt_subnet" {
  name    = "griffin-dev-mgmt-subnet"
  region  = var.region             
  project = var.project_id         
}

resource "google_compute_network" "vpc_prod" {
  project                 = var.project_id 
  name                    = var.vpc_name_prod
  auto_create_subnetworks = false # Important to set to false for custom subnets
  description             = "Production VPC"
}

resource "google_compute_subnetwork" "griffin-prod-wp_subnet" {
  project       = var.project_id
  name          = var.subnet_1_name_prod
  ip_cidr_range = var.subnet_1_cidr_prod
  network       = google_compute_network.vpc_prod.id
  region        = var.region
}

resource "google_compute_subnetwork" "griffin-prod-mngt_subnet" {
  project       = var.project_id
  name          = var.subnet_2_name_prod
  ip_cidr_range = var.subnet_2_cidr_prod
  network       = google_compute_network.vpc_prod.id
  region        = var.region
}

data "google_compute_subnetwork" "griffin-prod-mgmt_subnet" {
  name    = "griffin-prod-mgmt-subnet"
  region  = var.region             
  project = var.project_id         
}

resource "google_compute_instance" "bastion" {
  project      = var.project_id
  name         = var.bastion_name
  machine_type = var.bastion_machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Or your desired image
    }
  }

   network_interface {
     subnetwork = data.google_compute_subnetwork.griffin-dev-mgmt_subnet.id
     access_config {
       // Assign an external IP to the bastion host for SSH access
     }
  }

   network_interface {
     subnetwork = data.google_compute_subnetwork.griffin-prod-mngt_subnet.id
     }
  }

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
