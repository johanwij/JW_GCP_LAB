gcloud config set compute/region us-west1
gcloud config set compute/zone us-west1-a
gcloud services enable compute.googleapis.com
gcloud config set project qwiklabs-gcp-00-733a2e3c33a1
PROJECT_ID=qwiklabs-gcp-00-733a2e3c33a1
REGION="us-west1"
ZONE="us-west1-a"
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
FIREWALL_RULE_NAME_PROD="prod-ssh-external"

gcloud compute networks create "$VPC_NAME_DEV" \
    --project="$PROJECT_ID" \
    --subnet-mode=custom \
    --description="Development VPC"
gcloud compute networks subnets create "$SUBNET_1_NAME_DEV" \
    --network="$VPC_NAME_DEV" \
    --range="$SUBNET_1_CIDR_DEV" \
    --region="$REGION" \
    --project="$PROJECT_ID"
gcloud compute networks subnets create "$SUBNET_2_NAME_DEV" \
    --network="$VPC_NAME_DEV" \
    --range="$SUBNET_2_CIDR_DEV" \
    --region="$REGION" \
    --project="$PROJECT_ID"
gcloud compute networks create "$VPC_NAME_PROD" \
    --project="$PROJECT_ID" \
    --subnet-mode=custom \
    --description="Production VPC"
gcloud compute networks subnets create "$SUBNET_1_NAME_PROD" \
    --network="$VPC_NAME_PROD" \
    --range="$SUBNET_1_CIDR_PROD" \
    --region="$REGION" \
    --project="$PROJECT_ID"
gcloud compute networks subnets create "$SUBNET_2_NAME_PROD" \
    --network="$VPC_NAME_PROD" \
    --range="$SUBNET_2_CIDR_PROD" \
    --region="$REGION" \
    --project="$PROJECT_ID"   
MGMT_DEV_SUBNET_URI=$(gcloud compute networks subnets describe "$SUBNET_2_NAME_DEV" | grep selfLink | awk '{print $2}')
MGMT_PROD_SUBNET_URI=$(gcloud compute networks subnets describe "$SUBNET_2_NAME_PROD" | grep selfLink | awk '{print $2}')
gcloud compute instances create "$BASTION_NAME" \
    --project="$PROJECT_ID" \
    --zone="$ZONE" \
    --machine-type="$MACHINE_TYPE" \
    --image-family="$IMAGE_FAMILY" \
    --image-project="$IMAGE_PROJECT" \
    --network-interface subnet="$MGMT_DEV_SUBNET_URI" \
    --network-interface subnet="$MGMT_PROD_SUBNET_URI",no-address \
    --tags=ssh,bastion \
    --no-shielded-secure-boot \
    --no-shielded-vtpm \
    --no-shielded-integrity-monitoring
gcloud compute firewall-rules create "$FIREWALL_RULE_NAME_DEV" \
    --project="$PROJECT_ID" \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0  \
    --target-tags=ssh \
    --target-tags="$BASTION_NAME" \
    --network="$VPC_NAME_DEV"
gcloud compute firewall-rules create "$FIREWALL_RULE_NAME_PROD" \
    --project="$PROJECT_ID" \
    --allow=tcp:22 \
    --source-ranges=0.0.0.0/0  \
    --target-tags=ssh \
    --target-tags="$BASTION_NAME" \
    --network="$VPC_NAME_PROD"
gcloud sql instances create griffin-dev-db \
  --region=$REGION \
  --database-version=MYSQL_8_0 \
  --root-password="6#wM15Iy"