# Quick Start Guide - Docker & GitHub

## Step 1: Open WSL
```powershell
# In PowerShell
wsl
```

## Step 2: Go to Your Project
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
```

## Step 3: Check Everything is Ready
```bash
chmod +x check-docker-ready.sh
./check-docker-ready.sh
```

If all checks pass, continue. If not, fix the issues shown.

## Step 4: Build Docker Images
```bash
chmod +x build-images.sh
./build-images.sh
```

Wait 5-10 minutes for builds to complete.

## Step 5: Test with Docker Compose
```bash
docker compose up
```

Open http://localhost:3000 in your browser and test:
- Signup with a new account
- Login
- Add a lawyer

Press `Ctrl+C` to stop, then:
```bash
docker compose down
```

## Step 6: Push to Docker Hub
```bash
docker login
# Enter username: subhaniuduwawala
# Enter password (or token)

docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

## Step 7: Push to GitHub

### First Time Setup:
```bash
git init
git config user.name "Subhani Uduwawala"
git config user.email "your.email@example.com"
git remote add origin https://github.com/Subhaniuduwawala/LawPoint.git
```

### Add and Commit:
```bash
git add .
git status  # Check what will be committed
git commit -m "Initial commit: Full-stack LawPoint app with Docker"
```

### Push:
```bash
git branch -M main
git push -u origin main
```

Enter your GitHub username and Personal Access Token (not password).

## Done! ✅

Your project is now:
- ✅ Built as Docker images
- ✅ Pushed to Docker Hub
- ✅ Pushed to GitHub

Anyone can now run:
```bash
git clone https://github.com/Subhaniuduwawala/LawPoint.git
cd LawPoint
docker compose up
```

---

## If You Get Stuck

### Docker not found?
- Make sure Docker Desktop is running on Windows
- In WSL, try: `docker ps` to test

### Permission denied on scripts?
```bash
chmod +x *.sh
```

### Need GitHub Personal Access Token?
1. Go to: https://github.com/settings/tokens
2. Click "Generate new token (classic)"
3. Select: repo (all checkboxes)
4. Generate and copy the token
5. Use this as your password when pushing

### Repository doesn't exist?
1. Go to: https://github.com/new
2. Name: LawPoint
3. Don't initialize with README
4. Create repository
5. Try push again
