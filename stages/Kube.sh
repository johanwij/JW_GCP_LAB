PROJECT_ID=qwiklabs-gcp-02-bb9ae462b683
REGION="us-east4"
ZONE="us-east4-b"
VPC_NAME_DEV="griffin-dev-vpc"
SUBNET_1_NAME_DEV="griffin-dev-wp"
SUBNET_1_CIDR_DEV="192.168.16.0/20"
SUBNET_2_NAME_DEV="griffin-dev-mgmt"
SUBNET_2_CIDR_DEV="192.168.32.0/20"
VPC_NAME_PROD="griffin-prod-vpc"
SUBNET_1_NAME_PROD="griffin-prod-wp"
SUBNET_1_CIDR_PROD="192.168.48.0/20"
SUBNET_2_NAME_PROD="griffin-prod-mgmt"
SUBNET_2_CIDR_PROD="192.168.64.0/20"
BASTION_NAME="bastion-host"
MGMT_DEV_NETWORK="griffin-dev-vpc" 
MGMT_PROD_NETWORK="griffin-prod-vpc" 
MACHINE_TYPE="e2-medium" 
IMAGE_PROJECT="debian-cloud"
IMAGE_FAMILY="debian-11"
FIREWALL_RULE_NAME_DEV="dev-ssh-external"

gcloud container clusters create griffin-dev \
  --zone="$ZONE" \
  --machine-type="e2-standard-4" \
  --num-nodes=2 \
  --network=$VPC_NAME_DEV\
  --subnetwork=$SUBNET_1_NAME_DEV 