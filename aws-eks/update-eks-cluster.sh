#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Configure kubectl access
CLUSTER_NAME="abiola-devops"
AWS_REGION="us-east-1"

aws eks update-kubeconfig \
  --region "$AWS_REGION" \
  --name "$CLUSTER_NAME"

echo "kubectl context configured for $CLUSTER_NAME"
