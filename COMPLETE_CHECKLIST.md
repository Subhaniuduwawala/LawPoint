# 🚀 COMPLETE SETUP CHECKLIST

## What You Need to Do (Simple Version)

### ✅ Prerequisites (One-Time Setup)

1. **Install Docker in WSL** (if not installed):
   - Open PowerShell: `wsl`
   - Copy/paste from `NO_DOCKER_DESKTOP.md` file (the installation command)
   - Restart WSL: `exit`, then `wsl --shutdown`, then `wsl`

2. **Create GitHub Repository**:
   - Go to: https://github.com/new
   - Repository name: `LawPoint`
   - Keep it public
   - Don't initialize with README
   - Click "Create repository"

3. **Get GitHub Personal Access Token**:
   - Go to: https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select: `repo` (all checkboxes)
   - Generate and copy the token (save it somewhere safe!)

---

## 🎯 OPTION 1: One-Click Setup (Easiest!)

Just double-click: **`run-complete-setup.bat`**

This will:
- ✅ Build both Docker images
- ✅ Test them locally
- ✅ Ask if you want to push to Docker Hub
- ✅ Ask if you want to push to GitHub

**That's it!** Follow the prompts in the terminal.

---

## 🎯 OPTION 2: Manual Setup (Step by Step)

### 1. Open WSL
```powershell
wsl
```

### 2. Go to Project
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
```

### 3. Make Script Executable
```bash
chmod +x complete-setup.sh
```

### 4. Run Setup Script
```bash
./complete-setup.sh
```

Follow the prompts:
- It will build images (automatic)
- It will test locally (you test in browser)
- It will ask if you want to push to Docker Hub (enter y or n)
- It will ask if you want to push to GitHub (enter y or n)

---

## 🎯 OPTION 3: Completely Manual (If Scripts Don't Work)

### Step 1: Start Docker
```bash
sudo service docker start
```

### Step 2: Build Images
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint

# Backend
cd backend
docker build -t subhaniuduwawala/lawpoint-backend:latest .
cd ..

# Frontend
cd frontend
docker build -t subhaniuduwawala/lawpoint-frontend:latest .
cd ..
```

### Step 3: Test Locally
```bash
docker compose up -d
```

Open http://localhost:3000 in browser and test.

Stop when done:
```bash
docker compose down
```

### Step 4: Push to Docker Hub
```bash
docker login
# Username: subhaniuduwawala
# Password: (your Docker Hub password)

docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

### Step 5: Push to GitHub
```bash
git init
git config user.name "Your Name"
git config user.email "your@email.com"
git remote add origin https://github.com/Subhaniuduwawala/LawPoint.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
# Username: Subhaniuduwawala
# Password: (use your GitHub Personal Access Token)
```

---

## ✅ How to Verify Everything Worked

### Check Docker Images
```bash
docker images | grep lawpoint
```
Should show 2 images.

### Check Docker Hub
Go to: https://hub.docker.com/u/subhaniuduwawala
Should see both images listed.

### Check GitHub
Go to: https://github.com/Subhaniuduwawala/LawPoint
Should see all your code.

---

## 🆘 Troubleshooting

### "Docker daemon not running"
```bash
sudo service docker start
```

### "Permission denied" when running docker
```bash
sudo usermod -aG docker $USER
exit
# In PowerShell: wsl --shutdown
# Then: wsl
```

### GitHub push fails
- Make sure repository exists on GitHub
- Use Personal Access Token as password (not your GitHub password)

### Frontend build fails
Try with more memory:
```bash
docker build --memory=4g -t subhaniuduwawala/lawpoint-frontend:latest .
```

---

## 🎉 Success!

After completion, anyone can run your app with:

```bash
git clone https://github.com/Subhaniuduwawala/LawPoint.git
cd LawPoint
docker compose up
```

Then open http://localhost:3000

**Your project is now production-ready!** 🚀
