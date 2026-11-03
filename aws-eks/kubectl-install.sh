#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - kubectl installation
if [[ "$EUID" -ne 0 ]]; then
    echo "Run with: sudo bash $0"
    exit 1
fi

apt-get update
apt-get install -y curl

ARCH="$(dpkg --print-architecture)"
case "$ARCH" in
    amd64) KUBECTL_ARCH="amd64" ;;
    arm64) KUBECTL_ARCH="arm64" ;;
    *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
esac

VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"

curl -fsSLo /usr/local/bin/kubectl \
  "https://dl.k8s.io/release/${VERSION}/bin/linux/${KUBECTL_ARCH}/kubectl"

chmod 0755 /usr/local/bin/kubectl

kubectl version --client
