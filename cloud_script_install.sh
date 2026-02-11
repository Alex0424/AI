#!/bin/bash
# DISK: 60 GB, CPU: 4 vCPUs (2 cores), RAM: 16 GB
# Firewall: ingress TCP 443 and 80 for Caddy
# This script can be used as a startup / cloud-init script.

set -e

echo "=== 1 Prepare the server ==="
echo "Updating system and installing Docker & Docker Compose..."
sudo apt update
sudo apt install -y docker.io git curl

sudo systemctl enable docker --now

echo "Installing Docker Compose v2 plugin..."
sudo mkdir -p /usr/local/lib/docker/cli-plugins
sudo curl -SL https://github.com/docker/compose/releases/download/v2.25.0/docker-compose-linux-x86_64 \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

echo "Docker version:"
docker --version
echo "Docker Compose version:"
docker compose version

echo "Installing Caddy"
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo chmod o+r /usr/share/keyrings/caddy-stable-archive-keyring.gpg
sudo chmod o+r /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

echo "Writing Caddyfile"
cat <<EOF > /etc/caddy/Caddyfile
api.alexanderlindholm.net {
    reverse_proxy localhost:8000
    encode gzip
}
EOF

systemctl reload caddy

echo "Cloning project repository"
PROJECT_DIR="/home/$USER/AI"
echo "Cloning project..."
git clone https://github.com/Alex0424/AI.git "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo "=== 2 Building the stack ==="
echo "Building and starting Docker Compose..."
docker compose up -d --build

echo "Waiting for Ollama to be ready..."
sleep 15

echo "Pulling Ollama models inside container..."
docker exec ollama ollama pull nomic-embed-text
docker exec ollama ollama pull llama3.1

echo "=== 3 Verify services ==="
echo "Waiting a few seconds for services to start..."
sleep 10

echo "Ollama models:"
docker exec ollama ollama list

echo "Restarting API container..."
docker compose restart api

pub_ip=$(curl ifconfig.me)

echo "IP: $pub_ip"
echo "Deployment complete! API available at:"
echo "https://api.alexanderlindholm.net/chat"
