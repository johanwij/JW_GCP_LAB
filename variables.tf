variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  default     = "your-project-id" # Replace with your project ID
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-central1" # Replace with your desired region
}

variable "ZONE" {
  description = "The Google Cloud ZONE"
  type        = string
  default     = "us-central1-a" # Replace with your desired zone
}

variable "vpc_name_dev" {
  description = "Name of the development VPC network"
  type        = string
  default     = "dev-vpc" # Replace with your desired VPC name
}

variable "subnet_1_name_dev" {
  description = "Name of the first development subnet"
  type        = string
  default     = "dev-subnet-1" # Replace with your desired subnet name
}

variable "subnet_2_name_dev" {
  description = "Name of the second development subnet"
  type        = string
  default     = "dev-subnet-2" # Replace with your desired subnet name
}

variable "subnet_1_cidr_dev" {
  description = "CIDR range for the first development subnet"
  type        = string
  default     = "10.10.1.0/24" # Replace with your desired CIDR range
}

variable "subnet_2_cidr_dev" {
  description = "CIDR range for the second development subnet"
  type        = string
  default     = "10.10.2.0/24" # Replace with your desired CIDR range
}

variable "vpc_name_prod" {
  description = "Name of the production VPC network"
  type        = string
  default     = "prod-vpc" # Replace with your desired VPC name
}

variable "subnet_1_name_prod" {
  description = "Name of the first production subnet"
  type        = string
  default     = "prod-subnet-1" # Replace with your desired subnet name
}

variable "subnet_2_name_prod" {
  description = "Name of the second production subnet"
  type        = string
  default     = "prod-subnet-2" # Replace with your desired subnet name
}

variable "subnet_1_cidr_prod" {
  description = "CIDR range for the first production subnet"
  type        = string
  default     = "10.20.1.0/24" # Replace with your desired CIDR range
}

variable "subnet_2_cidr_prod" {
  description = "CIDR range for the second production subnet"
  type        = string
  default     = "10.20.2.0/24" # Replace with your desired CIDR range
}

variable "bastion_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "bastion-host"
}

variable "bastion_machine_type" {
  description = "Machine type for the bastion host"
  type        = string
  default     = "e2-micro"
}

variable "network_1" {
  description = "Network for the first network interface"
  type        = string
}

variable "subnetwork_1" {
  description = "Subnetwork for the first network interface"
  type        = string
}

variable "network_2" {
  description = "Network for the second network interface"
  type        = string
}

variable "subnetwork_2" {
  description = "Subnetwork for the second network interface"
  type        = string
}

variable "firewall_rule_name_dev" {
  description = "Name of the firewall rule for development"
  type        = string
  default     = "allow-ssh-dev"
}

variable "firewall_rule_name_prod" {
  description = "Name of the firewall rule for production"
  type        = string
  default     = "allow-ssh-prod"
}

variable "ssh_source_range" {
  description = "Source IP range for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Important: Restrict this in production!
}

variable "db_instance_name" {
  description = "Name of the Cloud SQL instance"
  type        = string
  default     = "griffin-dev-db"
}

variable "db_root_password" {
  description = "Root password for the Cloud SQL instance"
  type        = string
  sensitive   = true # Important: Mark the password as sensitive
  default     = "YourStrongRootPassword123!" # Replace with a strong password
}

variable "wp_user_password" {
  description = "Password for the wordpress user"
  type        = string
  sensitive   = true
  default     = "stormwind_rules"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "griffin-dev"
}

variable "machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "num_nodes" {
  description = "Number of nodes in the GKE cluster"
  type        = number
  default     = 2
}

variable "network" {
  description = "VPC network for the GKE cluster"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork for the GKE cluster"
  type        = string
}
