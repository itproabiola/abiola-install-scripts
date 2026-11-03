#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Latest stable kubectl installer

if [[ "$EUID" -ne 0 ]]; then
    echo "Run with: sudo bash $0"
    exit 1
fi

apt-get update
apt-get install -y curl

case "$(uname -m)" in
    x86_64) KUBECTL_ARCH="amd64" ;;
    aarch64|arm64) KUBECTL_ARCH="arm64" ;;
    *) echo "Unsupported architecture"; exit 1 ;;
esac

VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

BASE_URL="https://dl.k8s.io/release/${VERSION}/bin/linux/${KUBECTL_ARCH}"

curl -fsSL "$BASE_URL/kubectl" -o "$TMP_DIR/kubectl"
curl -fsSL "$BASE_URL/kubectl.sha256" -o "$TMP_DIR/kubectl.sha256"

EXPECTED="$(tr -d '[:space:]' < "$TMP_DIR/kubectl.sha256")"
echo "$EXPECTED  $TMP_DIR/kubectl" | sha256sum --check

install -m 0755 "$TMP_DIR/kubectl" /usr/local/bin/kubectl

kubectl version --client
