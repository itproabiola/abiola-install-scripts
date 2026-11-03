#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Production EKS cluster
eksctl create cluster \
  --name abiola-production \
  --version 1.22 \
  --region ca-central-1 \
  --nodegroup-name abiola-production-nodes \
  --node-type t3.2xlarge \
  --nodes 3 --nodes-min 1 --nodes-max 4 \
  --managed
