#!/usr/bin/env bash
set -Eeuo pipefail

if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this installer with sudo:"
    echo "sudo bash $0"
    exit 1
fi

LOG_FILE="/var/log/jenkins-install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=========================================="
echo " Abiola DevOps - Fresh Jenkins Installer"
echo "=========================================="

if ! grep -qi ubuntu /etc/os-release; then
    echo "ERROR: This installer requires Ubuntu."
    exit 1
fi

if ! command -v systemctl >/dev/null 2>&1; then
    echo "ERROR: systemctl is unavailable."
    exit 1
fi

if [[ "$(ps -p 1 -o comm= | tr -d ' ')" != "systemd" ]]; then
    echo "ERROR: systemd is not running as PID 1."
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "[1/7] Updating package lists..."
apt-get update

echo "[2/7] Installing Java 21 and dependencies..."
apt-get install -y fontconfig openjdk-21-jre wget curl ca-certificates

echo "[3/7] Checking Java..."
java -version

echo "[4/7] Configuring Jenkins signing key..."
install -d -m 0755 /etc/apt/keyrings

wget -q -O /etc/apt/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

chmod 0644 /etc/apt/keyrings/jenkins-keyring.asc

echo "[5/7] Adding Jenkins LTS repository..."
cat > /etc/apt/sources.list.d/jenkins.list <<'REPO'
deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/
REPO

apt-get update

echo "[6/7] Installing Jenkins..."
apt-get install -y jenkins

echo "[7/7] Enabling and starting Jenkins..."
systemctl daemon-reload
systemctl enable jenkins
systemctl restart jenkins

echo "Waiting for Jenkins to start..."

for attempt in {1..30}; do
        echo "Jenkins readiness check: ${attempt}/30"
    if systemctl is-active --quiet jenkins &&
       curl -fsS http://127.0.0.1:8080/login >/dev/null; then
        break
    fi
    sleep 5
done

if ! systemctl is-active --quiet jenkins; then
    echo "ERROR: Jenkins service failed to start."
    journalctl -u jenkins --no-pager -n 60
    exit 1
fi

if ! curl -fsS http://127.0.0.1:8080/login >/dev/null; then
    echo "ERROR: Jenkins HTTP endpoint is not responding."
    journalctl -u jenkins --no-pager -n 60
    exit 1
fi

echo
echo "SUCCESS: Jenkins is running."
echo "SUCCESS: Jenkins login page is responding."
echo
echo "Initial administrator password:"
echo "/var/lib/jenkins/secrets/initialAdminPassword"

if [[ -f /var/lib/jenkins/secrets/initialAdminPassword ]]; then
    echo "Initial password file exists."
else
    echo "WARNING: Initial password file is not available yet."
fi

echo
echo "Open this address in your browser:"
echo "http://localhost:8080"
echo
echo "Installation log: $LOG_FILE"
