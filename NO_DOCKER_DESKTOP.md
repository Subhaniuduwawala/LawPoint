# NO DOCKER DESKTOP - Quick Guide

## Install Docker in WSL (One-Time Setup)

### Step 1: Open WSL
```powershell
wsl
```

### Step 2: Run Installation Script

Copy and paste this entire block into WSL terminal:

```bash
# Update and install prerequisites
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker
sudo service docker start

echo ""
echo "✅ Docker installed!"
echo "Now restart WSL:"
echo "  1. Type: exit"
echo "  2. In PowerShell: wsl --shutdown"
echo "  3. Then: wsl"
```

### Step 3: Restart WSL
```bash
exit
```

In PowerShell:
```powershell
wsl --shutdown
wsl
```

### Step 4: Verify Installation
```bash
docker --version
docker run hello-world
```

If "hello-world" runs successfully, you're ready!

---

## Build and Push Docker Images

### Step 1: Start Docker Service (if needed)
```bash
sudo service docker start
```

### Step 2: Go to Project
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
```

### Step 3: Build Images
```bash
chmod +x build-images.sh
./build-images.sh
```

### Step 4: Test Locally
```bash
docker compose up
```

Open http://localhost:3000 in browser. Test signup/login.

Stop with `Ctrl+C`:
```bash
docker compose down
```

### Step 5: Push to Docker Hub
```bash
docker login
docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

### Step 6: Push to GitHub
```bash
git init
git config user.name "Your Name"
git config user.email "your@email.com"
git remote add origin https://github.com/Subhaniuduwawala/LawPoint.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

---

## Done! ✅

No Docker Desktop needed. Everything runs in WSL!
