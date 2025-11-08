#!/bin/bash

# LawPoint Pre-Build Checklist Script

echo "======================================"
echo "  LawPoint Pre-Build Checklist"
echo "======================================"
echo ""

ALL_GOOD=true

# Check Docker
echo -n "Checking Docker... "
if docker --version > /dev/null 2>&1; then
    VERSION=$(docker --version)
    echo "✅ $VERSION"
else
    echo "❌ Not installed or not running"
    ALL_GOOD=false
fi

# Check Docker daemon
echo -n "Checking Docker daemon... "
if docker ps > /dev/null 2>&1; then
    echo "✅ Running"
elif sudo docker ps > /dev/null 2>&1; then
    echo "✅ Running (needs sudo)"
    echo "   Tip: Add your user to docker group to avoid sudo"
else
    echo "❌ Not running"
    echo "   Start with: sudo service docker start"
    ALL_GOOD=false
fi

# Check Git
echo -n "Checking Git... "
if git --version > /dev/null 2>&1; then
    VERSION=$(git --version)
    echo "✅ $VERSION"
else
    echo "❌ Not installed"
    ALL_GOOD=false
fi

# Check backend files
echo -n "Checking backend/Dockerfile... "
if [ -f "backend/Dockerfile" ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
    ALL_GOOD=false
fi

# Check frontend files
echo -n "Checking frontend/Dockerfile... "
if [ -f "frontend/Dockerfile" ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
    ALL_GOOD=false
fi

# Check docker-compose
echo -n "Checking docker-compose.yml... "
if [ -f "docker-compose.yml" ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
    ALL_GOOD=false
fi

# Check backend dependencies
echo -n "Checking backend/package.json... "
if [ -f "backend/package.json" ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
    ALL_GOOD=false
fi

# Check frontend dependencies
echo -n "Checking frontend/package.json... "
if [ -f "frontend/package.json" ]; then
    echo "✅ Found"
else
    echo "❌ Missing"
    ALL_GOOD=false
fi

echo ""
echo "======================================"

if [ "$ALL_GOOD" = true ]; then
    echo "✅ All checks passed!"
    echo ""
    echo "You're ready to build Docker images:"
    echo "  ./build-images.sh"
    echo ""
    echo "Or manually:"
    echo "  cd backend && docker build -t subhaniuduwawala/lawpoint-backend:latest ."
    echo "  cd frontend && docker build -t subhaniuduwawala/lawpoint-frontend:latest ."
else
    echo "⚠️  Some checks failed"
    echo "Please fix the issues above before building"
fi

echo "======================================"
echo ""
