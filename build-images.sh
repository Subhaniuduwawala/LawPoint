#!/bin/bash

# LawPoint Docker Image Build Script for WSL/Linux
# This script builds both backend and frontend Docker images

set -e  # Exit on error

DOCKER_USER="subhaniuduwawala"
VERSION="latest"

echo "======================================"
echo "  LawPoint Docker Image Builder"
echo "======================================"
echo ""

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Error: Docker is not running!"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"
echo ""

# Build backend image
echo "📦 Building backend image..."
cd backend
docker build -t $DOCKER_USER/lawpoint-backend:$VERSION .
if [ $? -eq 0 ]; then
    echo "✅ Backend image built successfully"
else
    echo "❌ Backend build failed"
    exit 1
fi
cd ..

echo ""

# Build frontend image
echo "📦 Building frontend image..."
cd frontend
docker build -t $DOCKER_USER/lawpoint-frontend:$VERSION .
if [ $? -eq 0 ]; then
    echo "✅ Frontend image built successfully"
else
    echo "❌ Frontend build failed"
    exit 1
fi
cd ..

echo ""
echo "======================================"
echo "✅ All images built successfully!"
echo "======================================"
echo ""

# Show built images
echo "Built images:"
docker images | grep lawpoint

echo ""
echo "To push to Docker Hub, run:"
echo "  docker login"
echo "  docker push $DOCKER_USER/lawpoint-backend:$VERSION"
echo "  docker push $DOCKER_USER/lawpoint-frontend:$VERSION"
echo ""
echo "To test locally, run:"
echo "  docker compose up"
echo ""
