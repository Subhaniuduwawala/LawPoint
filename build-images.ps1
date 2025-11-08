# Docker Build and Push Script for LawPoint

# Set your Docker Hub username
# LawPoint Docker Image Build Script
# Update the DOCKER_USER variable with your Docker Hub username

$DOCKER_USER = "subhaniuduwawala"

# Build backend image
Write-Host "Building backend image..."
docker build -t ${DOCKER_USER}/lawpoint-backend:latest ./backend

# Build frontend image
Write-Host "Building frontend image..."
docker build -t ${DOCKER_USER}/lawpoint-frontend:latest ./frontend

Write-Host "`nImages built successfully!"
Write-Host "Backend: ${DOCKER_USER}/lawpoint-backend:latest"
Write-Host "Frontend: ${DOCKER_USER}/lawpoint-frontend:latest"

Write-Host "`nTo push images to Docker Hub, run:"
Write-Host "  docker login"
Write-Host "  docker push ${DOCKER_USER}/lawpoint-backend:latest"
Write-Host "  docker push ${DOCKER_USER}/lawpoint-frontend:latest"
