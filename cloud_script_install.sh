#!/bin/bash
# DISK: 60 GB, CPU: 4 vCPUs (2 cores), RAM: 16 GB
# Firewall: ingress TCP 8000
# This script can be used as a startup / cloud-init script.

set -e

# ------------------------------
# 1 Prepare the server
# ------------------------------
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

# ------------------------------
# 2 Clone AI repo from Git
# ------------------------------
PROJECT_DIR="/home/$USER/AI"
echo "Cloning project..."
git clone https://github.com/Alex0424/AI.git "$PROJECT_DIR"
cd "$PROJECT_DIR"

# -------------------------------
# 3 Install Ollama
# -------------------------------

#echo "Installing Ollama..."
#curl -fsSL https://ollama.com/install.sh | sh
#echo "Done"

# ------------------------------
# 3.5 Pull Ollama models
# ------------------------------
echo "Pulling Ollama embedding and LLM models..."
ollama pull nomic-embed-text
ollama pull llama3.1

echo "Check available Ollama models:"
ollama list

# ----------------------------------------------
# 4 Build and start Docker Compose stack
# ----------------------------------------------
echo "Building and starting Docker Compose..."
docker compose up -d --build

# ------------------------------
# 4.1 Wait for Ollama
# ------------------------------
echo "Waiting for Ollama to be ready..."
sleep 15

# ------------------------------
# 4.6 Pull models INSIDE Ollama container
# ------------------------------
echo "Pulling Ollama models inside container..."
docker exec ollama ollama pull nomic-embed-text
docker exec ollama ollama pull llama3.1

# ------------------------------
# 4.9 Restart API after models exist
# ------------------------------
echo "Restarting API container..."
docker compose restart api

# ------------------------------
# 5 Verify services
# ------------------------------
echo "Waiting a few seconds for services to start..."
sleep 10

echo "Ollama models:"
docker exec ollama ollama list

echo "Checking FastAPI logs..."
docker compose logs -f api

pub_ip=$(curl ifconfig.me)

echo "Deployment complete! FastAPI should be available at http://$pub_ip:8000/docs"

