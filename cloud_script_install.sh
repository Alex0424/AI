#!/bin/bash
# DISK: 60 GB, CPU: 4 vCPUs (2 cores), RAM: 16 GB, firewall: ingress 8000
# Add this script to startup script.

set -e

# ------------------------------
# 1 Prepare the server
# ------------------------------
echo "Updating system and installing Docker & Docker Compose..."
sudo apt update
sudo apt install -y docker.io docker-compose git
sudo systemctl enable docker --now

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

# ------------------------------
# 3 Pull Ollama models
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
docker compose build
docker compose up -d

# ------------------------------
# 5 Verify services
# ------------------------------
echo "Waiting a few seconds for services to start..."
sleep 10

echo "Checking FastAPI logs..."
docker compose logs -f api

echo "Deployment complete! FastAPI should be available at http://<your-server-ip>:8000/docs"

