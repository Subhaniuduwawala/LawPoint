#!/bin/bash

# LawPoint Complete Setup Script
# This script will guide you through the entire process

set -e

echo "=========================================="
echo "  LawPoint Complete Setup"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

DOCKER_USER="subhaniuduwawala"

# Function to print colored messages
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Check if Docker is installed
echo "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed!"
    echo ""
    echo "Please install Docker first:"
    echo "1. Run the installation commands from WSL_DOCKER_SETUP.md"
    echo "2. Or follow NO_DOCKER_DESKTOP.md"
    exit 1
fi
print_success "Docker is installed"

# Check if Docker daemon is running
echo "Checking Docker daemon..."
if ! docker ps &> /dev/null; then
    print_info "Docker daemon not running. Starting..."
    sudo service docker start
    sleep 2
    if ! docker ps &> /dev/null; then
        print_error "Failed to start Docker daemon"
        exit 1
    fi
fi
print_success "Docker daemon is running"

echo ""
echo "=========================================="
echo "  Step 1: Building Docker Images"
echo "=========================================="
echo ""

# Build backend
echo "Building backend image..."
cd backend
if docker build -t $DOCKER_USER/lawpoint-backend:latest .; then
    print_success "Backend image built"
else
    print_error "Backend build failed"
    exit 1
fi
cd ..

echo ""

# Build frontend
echo "Building frontend image..."
cd frontend
if docker build -t $DOCKER_USER/lawpoint-frontend:latest .; then
    print_success "Frontend image built"
else
    print_error "Frontend build failed"
    exit 1
fi
cd ..

echo ""
echo "=========================================="
echo "  Step 2: Verify Images"
echo "=========================================="
echo ""
docker images | grep lawpoint

echo ""
echo "=========================================="
echo "  Step 3: Test with Docker Compose"
echo "=========================================="
echo ""

print_info "Starting containers..."
docker compose up -d

echo ""
print_info "Waiting for services to start..."
sleep 10

echo ""
print_success "Services are running!"
echo ""
echo "You can now:"
echo "  • Open http://localhost:3000 in your browser"
echo "  • Test signup and login"
echo "  • Add lawyers"
echo ""
read -p "Press Enter after testing to continue..."

# Stop containers
print_info "Stopping containers..."
docker compose down

echo ""
echo "=========================================="
echo "  Step 4: Push to Docker Hub"
echo "=========================================="
echo ""

read -p "Do you want to push images to Docker Hub? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    print_info "Logging in to Docker Hub..."
    docker login
    
    echo ""
    print_info "Pushing backend image..."
    docker push $DOCKER_USER/lawpoint-backend:latest
    print_success "Backend image pushed"
    
    echo ""
    print_info "Pushing frontend image..."
    docker push $DOCKER_USER/lawpoint-frontend:latest
    print_success "Frontend image pushed"
    
    echo ""
    print_success "Images available at:"
    echo "  • https://hub.docker.com/r/$DOCKER_USER/lawpoint-backend"
    echo "  • https://hub.docker.com/r/$DOCKER_USER/lawpoint-frontend"
else
    print_info "Skipping Docker Hub push"
fi

echo ""
echo "=========================================="
echo "  Step 5: Push to GitHub"
echo "=========================================="
echo ""

read -p "Do you want to push to GitHub? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    
    # Check if git repo exists
    if [ ! -d .git ]; then
        print_info "Initializing git repository..."
        git init
        
        read -p "Enter your name: " git_name
        read -p "Enter your email: " git_email
        
        git config user.name "$git_name"
        git config user.email "$git_email"
        
        git remote add origin https://github.com/Subhaniuduwawala/LawPoint.git
    fi
    
    print_info "Staging files..."
    git add .
    
    print_info "Committing..."
    git commit -m "Initial commit: Full-stack LawPoint app with Docker support"
    
    print_info "Pushing to GitHub..."
    git branch -M main
    git push -u origin main
    
    print_success "Code pushed to GitHub!"
    echo "  • https://github.com/Subhaniuduwawala/LawPoint"
else
    print_info "Skipping GitHub push"
fi

echo ""
echo "=========================================="
echo "  🎉 SETUP COMPLETE!"
echo "=========================================="
echo ""
print_success "Your LawPoint project is ready!"
echo ""
echo "Summary:"
echo "  ✅ Docker images built"
echo "  ✅ Images tested locally"
echo "  ✅ Pushed to Docker Hub (if selected)"
echo "  ✅ Pushed to GitHub (if selected)"
echo ""
echo "Anyone can now run your app with:"
echo "  git clone https://github.com/Subhaniuduwawala/LawPoint.git"
echo "  cd LawPoint"
echo "  docker compose up"
echo ""
echo "Or pull images directly:"
echo "  docker pull $DOCKER_USER/lawpoint-backend:latest"
echo "  docker pull $DOCKER_USER/lawpoint-frontend:latest"
echo ""
