#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - Latest stable Kops installer

if [[ "$EUID" -ne 0 ]]; then
    echo "Run with: sudo bash $0"
    exit 1
fi

apt-get update
apt-get install -y curl

case "$(uname -m)" in
    x86_64) KOPS_ARCH="amd64" ;;
    aarch64|arm64) KOPS_ARCH="arm64" ;;
    *) echo "Unsupported architecture"; exit 1 ;;
esac

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

BASE_URL="https://github.com/kubernetes/kops/releases/latest/download"
BINARY="kops-linux-${KOPS_ARCH}"

curl -fsSL "$BASE_URL/$BINARY" -o "$TMP_DIR/kops"
curl -fsSL "$BASE_URL/$BINARY.sha256" -o "$TMP_DIR/kops.sha256"

EXPECTED="$(tr -d '[:space:]' < "$TMP_DIR/kops.sha256")"
echo "$EXPECTED  $TMP_DIR/kops" | sha256sum --check

install -m 0755 "$TMP_DIR/kops" /usr/local/bin/kops

kops version
