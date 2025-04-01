CLUSTER_NAME="griffin-dev"
CLUSTER_ZONE=$ZONE
NAMESPACE="default"
SERVICE_NAME="wordpress"

EXTERNAL_IP=$(kubectl get service "$SERVICE_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].ip}' --context="gke_${PROJECT_ID}_${CLUSTER_ZONE}_${CLUSTER_NAME}")

gcloud monitoring uptime create \
  --display-name="WordPress Uptime Check" \
  --path="/" \
  --port=80 \
  --resource-type=uptime-url \
  --resource-labels=host=$EXTERNAL_IP \
  --period="1" \
  --timeout="10" \
  --project="$PROJECT_ID"
