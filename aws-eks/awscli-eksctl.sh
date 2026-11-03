#!/usr/bin/env bash
set -Eeuo pipefail

echo "======================================"
echo " AWS CLI v2 and eksctl Installation"
echo "======================================"

if [[ "$EUID" -ne 0 ]]; then
    echo "Run with: sudo bash $0"
    exit 1
fi

apt-get update
apt-get install -y curl unzip tar

ARCH="$(uname -m)"

case "$ARCH" in
    x86_64)
        AWS_ARCH="x86_64"
        EKS_ARCH="amd64"
        ;;
    aarch64|arm64)
        AWS_ARCH="aarch64"
        EKS_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "[1/2] Installing AWS CLI v2..."

curl -fsSL \
    "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" \
    -o "$TEMP_DIR/awscliv2.zip"

unzip -q "$TEMP_DIR/awscliv2.zip" -d "$TEMP_DIR"
"$TEMP_DIR/aws/install" --update

aws --version

echo "[2/2] Installing eksctl..."

curl -fsSL \
    "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_Linux_${EKS_ARCH}.tar.gz" \
    -o "$TEMP_DIR/eksctl.tar.gz"

tar -xzf "$TEMP_DIR/eksctl.tar.gz" -C "$TEMP_DIR"
install -m 0755 "$TEMP_DIR/eksctl" /usr/local/bin/eksctl

eksctl version

echo
echo "AWS CLI v2 and eksctl installation completed."
