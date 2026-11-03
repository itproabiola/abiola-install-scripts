#!/bin/bash
# ------------------------------------------------------------
# SonarQube 10.x installation script for Ubuntu 22.04
# ------------------------------------------------------------
# Run as root or sudo ./install-sonarqube.sh
# Access: http://<server-ip>:9000  (default login: admin / admin)
# ------------------------------------------------------------

set -e

echo "=== Update system packages ==="
apt update -y && apt upgrade -y

echo "=== Install dependencies ==="
apt install -y openjdk-17-jdk unzip wget postgresql postgresql-contrib

echo "=== Configure PostgreSQL ==="
sudo -u postgres psql -c "CREATE USER sonar WITH ENCRYPTED PASSWORD 'sonar';" || true
sudo -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;" || true
sudo -u postgres psql -c "ALTER SYSTEM SET max_connections = '100';"

systemctl enable postgresql
systemctl restart postgresql

echo "=== Create SonarQube user ==="
useradd -m -d /opt/sonarqube -s /bin/bash sonar || true
echo "=== Create SonarQube user ==="
useradd -m -d /opt/sonarqube -s /bin/bash sonar || true

echo "=== Download SonarQube (Community Edition) ==="
cd /tmp
SONAR_VERSION=10.5.1.90531
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-${SONAR_VERSION}.zip
unzip sonarqube-${SONAR_VERSION}.zip -d /opt/
mv /opt/sonarqube-${SONAR_VERSION} /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube

echo "=== Configure SonarQube database connection ==="
cat >> /opt/sonarqube/conf/sonar.properties <<EOF

# PostgreSQL database connection
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube

# Web server
sonar.web.host=0.0.0.0
sonar.web.port=9000

EOF
echo "=== Create systemd service ==="
cat > /etc/systemd/system/sonarqube.service <<EOF
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube

echo "=== Configure sysctl limits ==="
cat >> /etc/security/limits.conf <<EOF
sonar   -   nofile   65536
sonar   -   nproc    4096
EOF

sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072

echo "=== SonarQube installation complete ==="
echo "Access SonarQube at: http://$(hostname -I | awk '{print $1}'):9000"
