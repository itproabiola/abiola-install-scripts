#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Configure kubectl for the current user

if [[ "$EUID" -eq 0 ]]; then
    echo "Run this script as your normal Kubernetes administrator user, not root."
    exit 1
fi

KUBE_DIR="${HOME}/.kube"

if [[ ! -f /etc/kubernetes/admin.conf ]]; then
    echo "ERROR: /etc/kubernetes/admin.conf not found."
    echo "Run this on an initialized Kubernetes control-plane node."
    exit 1
fi

mkdir -p "$KUBE_DIR"
sudo cp /etc/kubernetes/admin.conf "$KUBE_DIR/config"
sudo chown "$(id -u):$(id -g)" "$KUBE_DIR/config"
chmod 600 "$KUBE_DIR/config"

echo "kubectl configuration installed successfully."
kubectl get pods -o wide -n kube-system

# Install a CNI plugin separately, ensuring it supports your Kubernetes version.
