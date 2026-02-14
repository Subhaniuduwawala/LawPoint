#!/bin/bash
set -e

# Update system
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Docker prerequisites
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Add Docker repository
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install Docker
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create application directory
mkdir -p /home/ubuntu/lawpoint
cd /home/ubuntu/lawpoint

# Create docker-compose.yml
cat > docker-compose.yml <<'EOF'
version: '3.8'
services:
  mongo:
    image: mongo:6.0
    restart: unless-stopped
    volumes:
      - mongo-data:/data/db
    ports:
      - "27017:27017"

  backend:
    image: subhaniuduwawala/lawpoint-backend:latest
    restart: unless-stopped
    ports:
      - "4000:4000"
    environment:
      MONGO_URI: "mongodb://mongo:27017/lawpoint"
      PORT: "4000"
    depends_on:
      - mongo

  frontend:
    image: subhaniuduwawala/lawpoint-frontend:latest
    restart: unless-stopped
    ports:
      - "3000:80"
    depends_on:
      - backend

volumes:
  mongo-data: {}
EOF

# Fix permissions
sudo chown -R ubuntu:ubuntu /home/ubuntu/lawpoint

# Start containers
docker-compose up -d

echo "LawPoint deployment completed!"
