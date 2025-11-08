# LawPoint - Docker Build & GitHub Push Instructions

## Prerequisites Check

### 1. Check if WSL is installed
```powershell
wsl --list --verbose
```

If not installed, install it:
```powershell
wsl --install
```

### 2. Check if Docker Desktop is installed
- Download from: https://www.docker.com/products/docker-desktop
- Make sure "Use WSL 2 based engine" is enabled in Docker Desktop settings

---

## Part 1: Build Docker Images in WSL

### Step 1: Open WSL Terminal
```powershell
wsl
```

### Step 2: Navigate to Your Project
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
```

### Step 3: Verify Files Are There
```bash
ls -la
# You should see: backend/, frontend/, docker-compose.yml, README.md
```

### Step 4: Check Docker is Running
```bash
docker --version
docker ps
```

If you get "Cannot connect to Docker daemon", start Docker Desktop on Windows first.

### Step 5: Build Backend Image
```bash
cd backend
docker build -t subhaniuduwawala/lawpoint-backend:latest .
```

Wait for the build to complete (may take 2-5 minutes).

### Step 6: Build Frontend Image
```bash
cd ../frontend
docker build -t subhaniuduwawala/lawpoint-frontend:latest .
```

Wait for the build to complete (may take 3-7 minutes).

### Step 7: Verify Images Were Built
```bash
docker images | grep lawpoint
```

You should see:
```
subhaniuduwawala/lawpoint-backend    latest    ...    ...    ...
subhaniuduwawala/lawpoint-frontend   latest    ...    ...    ...
```

---

## Part 2: Test Docker Images Locally

### Step 1: Go Back to Project Root
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
```

### Step 2: Stop Any Running Containers
```bash
docker ps
docker stop $(docker ps -aq)  # Stop all running containers
```

### Step 3: Start with Docker Compose
```bash
docker compose up
```

Watch for these messages:
- ✅ MongoDB: "Waiting for connections"
- ✅ Backend: "LawPoint backend listening on port 4000"
- ✅ Frontend: nginx started

### Step 4: Test in Browser (from Windows)
Open: http://localhost:3000

- Try to signup
- Try to login
- Try to add a lawyer

### Step 5: Stop Docker Compose
Press `Ctrl+C` in the terminal, then:
```bash
docker compose down
```

---

## Part 3: Push Images to Docker Hub

### Step 1: Login to Docker Hub
```bash
docker login
```

Enter your Docker Hub username: `subhaniuduwawala`
Enter your password (or token)

### Step 2: Push Backend Image
```bash
docker push subhaniuduwawala/lawpoint-backend:latest
```

### Step 3: Push Frontend Image
```bash
docker push subhaniuduwawala/lawpoint-frontend:latest
```

### Step 4: Verify on Docker Hub
Go to: https://hub.docker.com/u/subhaniuduwawala
You should see both images listed.

---

## Part 4: Push Code to GitHub

### Step 1: Initialize Git (if not already)
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
git init
```

### Step 2: Create .gitignore File
```bash
cat > .gitignore << 'EOF'
# Node modules
node_modules/
npm-debug.log*

# Environment variables
.env
.env.local

# Build outputs
dist/
build/

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Logs
logs/
*.log

# Database
data/

# Temporary files
*.tmp
*.temp
EOF
```

### Step 3: Configure Git
```bash
git config user.name "Your Name"
git config user.email "your.email@example.com"
```

### Step 4: Add Remote Repository
```bash
git remote add origin https://github.com/Subhaniuduwawala/LawPoint.git
```

### Step 5: Stage All Files
```bash
git add .
```

### Step 6: Check What Will Be Committed
```bash
git status
```

Make sure node_modules/ folders are NOT listed (they should be ignored).

### Step 7: Commit Changes
```bash
git commit -m "Initial commit: Full-stack LawPoint app with authentication and Docker support"
```

### Step 8: Push to GitHub
```bash
git branch -M main
git push -u origin main
```

Enter your GitHub username and password (or personal access token).

### Step 9: Verify on GitHub
Go to: https://github.com/Subhaniuduwawala/LawPoint
You should see all your files there!

---

## Troubleshooting

### Problem: "Cannot connect to Docker daemon"
**Solution:**
1. Open Docker Desktop on Windows
2. Wait for it to fully start (green icon in system tray)
3. In WSL, try again: `docker ps`

### Problem: "permission denied" when running docker
**Solution:**
```bash
sudo usermod -aG docker $USER
```
Then restart WSL: `exit` and `wsl` again.

### Problem: Build fails with "no space left on device"
**Solution:**
```bash
docker system prune -a
```

### Problem: Frontend build fails in Docker
**Solution:**
Check frontend/Dockerfile has enough memory:
```bash
docker build --memory=4g -t subhaniuduwawala/lawpoint-frontend:latest .
```

### Problem: Git push asks for password but fails
**Solution:**
You need a Personal Access Token (PAT) instead of password:
1. Go to: https://github.com/settings/tokens
2. Generate new token (classic)
3. Select scopes: `repo` (all)
4. Copy the token
5. Use it as password when pushing

### Problem: "remote: Repository not found"
**Solution:**
Make sure the repository exists on GitHub:
1. Go to: https://github.com/new
2. Create repository named: `LawPoint`
3. Don't initialize with README
4. Then try pushing again

---

## Quick Reference Commands

### Check Everything is Ready:
```bash
# In WSL
docker --version          # Should show version
git --version             # Should show version
docker images | grep lawpoint  # Should show 2 images
```

### Clean Up Docker:
```bash
docker compose down       # Stop containers
docker system prune       # Clean up unused data
```

### Pull Your Images on Another Machine:
```bash
docker pull subhaniuduwawala/lawpoint-backend:latest
docker pull subhaniuduwawala/lawpoint-frontend:latest
docker compose up
```

---

## Summary

After completing all steps, you will have:
✅ Built Docker images for backend and frontend
✅ Tested the full stack with Docker Compose
✅ Pushed images to Docker Hub (public)
✅ Pushed source code to GitHub repository
✅ Anyone can now run: `docker compose up` to start your app

---

## Next Steps (Optional)

1. **Add CI/CD**: Set up GitHub Actions to auto-build images on push
2. **Deploy**: Deploy to AWS, Azure, or Heroku
3. **Add Tags**: Tag images with versions (v1.0.0, v1.0.1, etc.)
4. **Documentation**: Add screenshots to README.md
5. **Environment Variables**: Use secrets for production JWT_SECRET

Good luck! 🚀
