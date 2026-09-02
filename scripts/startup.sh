#!/bin/bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "=== Atlantis Server Initialization Started ==="

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

# 3. Create Atlantis Directory & Docker Compose Configuration
mkdir -p /opt/atlantis
mkdir -p /opt/atlantis/data

cat <<'EOF' > /opt/atlantis/docker-compose.yml
services:
  atlantis:
    image: runatlantis/atlantis:latest
    container_name: atlantis
    restart: always
    ports:
      - "4141:4141"
    environment:
      - ATLANTIS_ATLANTIS_URL=${ATLANTIS_URL}
      - ATLANTIS_GH_USER=${ATLANTIS_GH_USER}
      - ATLANTIS_GH_TOKEN=${ATLANTIS_GH_TOKEN}
      - ATLANTIS_GH_WEBHOOK_SECRET=${ATLANTIS_GH_WEBHOOK_SECRET}
      - ATLANTIS_REPO_ALLOWLIST=${ATLANTIS_REPO_ALLOWLIST:-github.com/tribagus6/*}
      - ATLANTIS_AUTOPLAN_FILE_LIST=**/*.tf,**/*.tfvars,**/*.hcl
    volumes:
      - /opt/atlantis/data:/atlantis
      - /var/run/docker.sock:/var/run/docker.sock
    user: root
EOF

# 4. Fetch Public IP for Atlantis URL
PUBLIC_IP=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip || echo "localhost")

if [ ! -f /opt/atlantis/.env ]; then
  cat <<EOF > /opt/atlantis/.env
ATLANTIS_URL=http://${PUBLIC_IP}:4141
ATLANTIS_GH_USER=tribagus6
ATLANTIS_GH_TOKEN=REPLACE_WITH_YOUR_GITHUB_PAT
ATLANTIS_GH_WEBHOOK_SECRET=REPLACE_WITH_YOUR_WEBHOOK_SECRET
ATLANTIS_REPO_ALLOWLIST=github.com/tribagus6/*
EOF
fi

# 5. Create Systemd Service for Atlantis
cat <<'EOF' > /etc/systemd/system/atlantis.service
[Unit]
Description=Atlantis Terraform Pull Request Automation
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/atlantis
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable atlantis.service
systemctl start atlantis.service || true

echo "=== Atlantis Server Initialization Completed ==="
