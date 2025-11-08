# LawPoint - Docker Setup in WSL (Without Docker Desktop)

## Step 1: Install Docker in WSL

Open WSL and run these commands:

```bash
# Update packages
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add your user to docker group (to run without sudo)
sudo usermod -aG docker $USER

# Start Docker service
sudo service docker start
```

**After adding yourself to docker group, restart WSL:**
```powershell
# In PowerShell
wsl --shutdown
wsl
```

## Step 2: Verify Docker Installation

```bash
# Check Docker version
docker --version

# Check if Docker is running
sudo service docker status

# Test Docker (should work without sudo after restart)
docker run hello-world
```

If `docker run hello-world` works, you're ready!

---

## Step 3: Navigate to Your Project

```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
```

---

## Step 4: Build Docker Images

```bash
# Make scripts executable
chmod +x *.sh

# Build images
./build-images.sh
```

Or manually:

```bash
# Build backend
cd backend
docker build -t subhaniuduwawala/lawpoint-backend:latest .
cd ..

# Build frontend
cd frontend
docker build -t subhaniuduwawala/lawpoint-frontend:latest .
cd ..
```

---

## Step 5: Test with Docker Compose

```bash
# Start services
docker compose up
```

Open http://localhost:3000 in your Windows browser.

Stop with `Ctrl+C`, then:
```bash
docker compose down
```

---

## Step 6: Push to Docker Hub

```bash
# Login to Docker Hub
docker login
# Username: subhaniuduwawala
# Password: (your Docker Hub password or token)

# Push images
docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

---

## Step 7: Push to GitHub

```bash
# First time setup
git init
git config user.name "Subhani Uduwawala"
git config user.email "your.email@example.com"
git remote add origin https://github.com/Subhaniuduwawala/LawPoint.git

# Add and commit
git add .
git commit -m "Initial commit: Full-stack LawPoint app with Docker"

# Push to GitHub
git branch -M main
git push -u origin main
```

For password, use a GitHub Personal Access Token:
1. Go to: https://github.com/settings/tokens
2. Generate new token (classic)
3. Select: repo (all)
4. Use token as password

---

## Troubleshooting

### Docker service not starting?
```bash
sudo service docker start
```

### Permission denied when running docker?
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Restart WSL
exit
# In PowerShell: wsl --shutdown
# Then: wsl
```

### Check if Docker daemon is running:
```bash
sudo service docker status
# Should show: "Docker is running"
```

### Can't access localhost:3000 from Windows?
Make sure you're using `localhost` not `127.0.0.1`, and that WSL2 networking is working.

---

## Quick Commands Reference

```bash
# Start Docker service
sudo service docker start

# Stop Docker service
sudo service docker stop

# Check Docker status
sudo service docker status

# View running containers
docker ps

# View all containers
docker ps -a

# View images
docker images

# Clean up Docker
docker system prune -a
```

---

## Auto-start Docker on WSL Launch (Optional)

Add this to your `~/.bashrc`:

```bash
# Start Docker service if not running
if ! service docker status > /dev/null 2>&1; then
    sudo service docker start
fi
```

Then reload:
```bash
source ~/.bashrc
```

---

## Summary

You now have:
- ✅ Docker installed directly in WSL (no Docker Desktop needed)
- ✅ Ability to build and run containers
- ✅ Docker Compose support
- ✅ Ready to push to Docker Hub and GitHub

**No Windows Docker Desktop required!** 🎉
