#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Development EKS cluster
eksctl create cluster \
  --name abiola-devops \
  --version 1.24 \
  --region us-east-1 \
  --nodegroup-name abiola-devops-nodes \
  --node-type t2.medium \
  --nodes 3 --nodes-min 1 --nodes-max 4 \
  --managed

# Abiola DevOps - Staging EKS cluster
eksctl create cluster \
  --name abiola-staging \
  --version 1.27 \
  --region ca-central-1 \
  --nodegroup-name abiola-staging-nodes \
  --node-type t2.medium \
  --nodes 3 --nodes-min 1 --nodes-max 4 \
  --managed
