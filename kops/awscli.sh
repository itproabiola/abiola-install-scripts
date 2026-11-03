#!/usr/bin/env bash
set -Eeuo pipefail

# Abiola DevOps - AWS CLI v2 installer

if [[ "$EUID" -ne 0 ]]; then
    echo "Run with: sudo bash $0"
    exit 1
fi

apt-get update
apt-get install -y curl unzip

case "$(uname -m)" in
    x86_64) AWS_ARCH="x86_64" ;;
    aarch64|arm64) AWS_ARCH="aarch64" ;;
    *) echo "Unsupported architecture"; exit 1 ;;
esac

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" \
    -o "$TMP_DIR/awscliv2.zip"

unzip -q "$TMP_DIR/awscliv2.zip" -d "$TMP_DIR"

if command -v aws >/dev/null 2>&1; then
    "$TMP_DIR/aws/install" --update
else
    "$TMP_DIR/aws/install"
fi

aws --version
