#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Staging cluster deletion
CLUSTER_NAME="abiola-staging"
AWS_REGION="ca-central-1"

echo "WARNING: This will permanently delete EKS cluster: $CLUSTER_NAME"
read -r -p "Type DELETE-$CLUSTER_NAME to continue: " CONFIRM

if [[ "$CONFIRM" != "DELETE-$CLUSTER_NAME" ]]; then
    echo "Deletion cancelled."
    exit 1
fi

eksctl delete cluster \
  --name "$CLUSTER_NAME" \
  --region "$AWS_REGION"
