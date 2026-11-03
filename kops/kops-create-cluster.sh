#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Kops Kubernetes cluster
CLUSTER_NAME="abiola.k8s.local"
AWS_ZONE="us-east-1a"
NETWORKING="weave"
MASTER_SIZE="t2.large"
NODE_SIZE="t2.large"
NODE_COUNT=3

echo "Cluster: $CLUSTER_NAME"
echo "Availability Zone: $AWS_ZONE"
echo "Master: $MASTER_SIZE"
echo "Worker nodes: $NODE_COUNT x $NODE_SIZE"

echo
echo "WARNING: This operation provisions AWS infrastructure."
read -r -p "Type CREATE-$CLUSTER_NAME to continue: " CONFIRM

if [[ "$CONFIRM" != "CREATE-$CLUSTER_NAME" ]]; then
    echo "Cluster creation cancelled."
    exit 1
fi

kops create cluster \
    --name "$CLUSTER_NAME" \
    --zones "$AWS_ZONE" \
    --networking "$NETWORKING" \
    --master-size "$MASTER_SIZE" \
    --master-count 1 \
    --node-size "$NODE_SIZE" \
    --node-count "$NODE_COUNT"

echo "Kops cluster configuration submitted."
