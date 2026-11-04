#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "${1:-}" != "--execute" || "${CONFIRM_LAUNCH:-}" != "YES" ]]; then
  echo "DRY RUN: no EKS clusters created."
  echo "To proceed, use --execute with CONFIRM_LAUNCH=YES."
  exit 0
fi

eksctl create cluster --name abiola-devops --version 1.37 --region us-east-1 --nodegroup-name abiola-devops-nodes --node-type t3.medium --nodes 1 --nodes-min 1 --nodes-max 2 --managed

eksctl create cluster --name abiola-staging --version 1.37 --region ca-central-1 --nodegroup-name abiola-staging-nodes --node-type t3.medium --nodes 1 --nodes-min 1 --nodes-max 2 --managed
