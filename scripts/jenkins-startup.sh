#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "=== Jenkins CI/CD Server Initialization Started ==="

# 1. Update and install prerequisites
apt-get update -y
apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    jq

# 2. Install Docker CE and Docker Compose plugin
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

# 3. Create Jenkins Directory Structure and Permissions
mkdir -p /opt/jenkins
mkdir -p /opt/jenkins/jenkins_home
chown -R 1000:1000 /opt/jenkins/jenkins_home

# 4. Create Docker Compose Configuration for Jenkins
cat <<'COMPOSE_EOF' > /opt/jenkins/docker-compose.yml
services:
  jenkins:
    image: jenkins/jenkins:lts-jdk17
    container_name: jenkins
    restart: always
    privileged: true
    user: root
    ports:
      - "8080:8080"
      - "50000:50000"
    environment:
      - JAVA_OPTS=-Djenkins.install.runSetupWizard=true
    volumes:
      - /opt/jenkins/jenkins_home:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/bin/docker:/usr/bin/docker
COMPOSE_EOF

# 5. Create Systemd Service for Jenkins
cat <<'SERVICE_EOF' > /etc/systemd/system/jenkins.service
[Unit]
Description=Jenkins CI/CD Automation Server in Docker
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/jenkins
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
SERVICE_EOF

systemctl daemon-reload
systemctl enable jenkins.service
systemctl start jenkins.service || true

echo "=== Jenkins CI/CD Server Initialization Completed ==="
