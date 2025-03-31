variable "project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
  default     = "qwiklabs-gcp-04-961656f292a1" # Replace with your project ID
}

variable "region" {
  description = "The Google Cloud region"
  type        = string
  default     = "us-east4" # Replace with your desired region
}

variable "zone" {
  description = "The Google Cloud ZONE"
  type        = string
  default     = "us-east4-a" # Replace with your desired zone
}

variable "vpc_name_dev" {
  description = "Name of the development VPC network"
  type        = string
  default     = "griffin-dev-vpc" # Replace with your desired VPC name
}

variable "subnet_1_name_dev" {
  description = "Name of the first development subnet"
  type        = string
  default     = "griffin-dev-wp" # Replace with your desired subnet name
}

variable "subnet_2_name_dev" {
  description = "Name of the second development subnet"
  type        = string
  default     = "griffin-dev-mgmt" # Replace with your desired subnet name
}

variable "subnet_1_cidr_dev" {
  description = "CIDR range for the first development subnet"
  type        = string
  default     = "92.168.16.0/20" # Replace with your desired CIDR range
}

variable "subnet_2_cidr_dev" {
  description = "CIDR range for the second development subnet"
  type        = string
  default     = "192.168.32.0/20" # Replace with your desired CIDR range
}

variable "vpc_name_prod" {
  description = "Name of the production VPC network"
  type        = string
  default     = "griffin-prod-vpc" # Replace with your desired VPC name
}

variable "subnet_1_name_prod" {
  description = "Name of the first production subnet"
  type        = string
  default     = "griffin-prod-wp" # Replace with your desired subnet name
}

variable "subnet_2_name_prod" {
  description = "Name of the second production subnet"
  type        = string
  default     = "griffin-prod-mgmt" # Replace with your desired subnet name
}

variable "subnet_1_cidr_prod" {
  description = "CIDR range for the first production subnet"
  type        = string
  default     = "192.168.48.0/20" # Replace with your desired CIDR range
}

variable "subnet_2_cidr_prod" {
  description = "CIDR range for the second production subnet"
  type        = string
  default     = "192.168.64.0/20" # Replace with your desired CIDR range
}

variable "bastion_name" {
  description = "Name of the bastion host"
  type        = string
  default     = "bastion-host"
}

variable "bastion_machine_type" {
  description = "Machine type for the bastion host"
  type        = string
  default     = "e2-medium"
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
  default     = ["0.0.0.0/0"] 
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


