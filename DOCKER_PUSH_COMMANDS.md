# How to Push Docker Images to Docker Hub

## Complete Step-by-Step Commands

### Step 1: Login to Docker Hub

```bash
docker login
```

**Enter when prompted:**
- Username: `subhaniuduwawala`
- Password: Your Docker Hub Access Token (NOT password!)

**Alternative - Login with username directly:**
```bash
docker login -u subhaniuduwawala
```

---

### Step 2: Build Docker Images

**Build Backend Image:**
```bash
cd backend
docker build -t subhaniuduwawala/lawpoint-backend:latest .
cd ..
```

**Build Frontend Image:**
```bash
cd frontend
docker build -t subhaniuduwawala/lawpoint-frontend:latest .
cd ..
```

**Or build from root directory:**
```bash
# Backend
docker build -t subhaniuduwawala/lawpoint-backend:latest ./backend

# Frontend
docker build -t subhaniuduwawala/lawpoint-frontend:latest ./frontend
```

---

### Step 3: Tag Images (Optional - add version tags)

```bash
# Get current git commit
$commit = git rev-parse --short HEAD

# Tag backend
docker tag subhaniuduwawala/lawpoint-backend:latest subhaniuduwawala/lawpoint-backend:$commit

# Tag frontend
docker tag subhaniuduwawala/lawpoint-frontend:latest subhaniuduwawala/lawpoint-frontend:$commit
```

---

### Step 4: Push Images to Docker Hub

**Push Backend:**
```bash
docker push subhaniuduwawala/lawpoint-backend:latest
```

**Push Frontend:**
```bash
docker push subhaniuduwawala/lawpoint-frontend:latest
```

**Push with commit tag (if you tagged):**
```bash
docker push subhaniuduwawala/lawpoint-backend:$commit
docker push subhaniuduwawala/lawpoint-frontend:$commit
```

**Or push all tags at once:**
```bash
docker push subhaniuduwawala/lawpoint-backend --all-tags
docker push subhaniuduwawala/lawpoint-frontend --all-tags
```

---

## 🚀 COMPLETE ONE-LINER SCRIPT

Copy and paste this entire block to build and push everything:

```powershell
# Build and push backend
docker build -t subhaniuduwawala/lawpoint-backend:latest ./backend
docker push subhaniuduwawala/lawpoint-backend:latest

# Build and push frontend
docker build -t subhaniuduwawala/lawpoint-frontend:latest ./frontend
docker push subhaniuduwawala/lawpoint-frontend:latest

echo "✅ Both images pushed successfully!"
```

---

## 🔄 Using Docker Compose to Build

If you want to use docker-compose:

```bash
# Build all images
docker compose build

# Tag the images
docker tag lawpoint-backend:latest subhaniuduwawala/lawpoint-backend:latest
docker tag lawpoint-frontend:latest subhaniuduwawala/lawpoint-frontend:latest

# Push to Docker Hub
docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

---

## ✅ Verify Images on Docker Hub

After pushing, verify at:
- Backend: https://hub.docker.com/r/subhaniuduwawala/lawpoint-backend
- Frontend: https://hub.docker.com/r/subhaniuduwawala/lawpoint-frontend

---

## 🔍 Useful Docker Commands

**Check local images:**
```bash
docker images | grep lawpoint
```

**Check image size:**
```bash
docker images subhaniuduwawala/lawpoint-backend
docker images subhaniuduwawala/lawpoint-frontend
```

**Remove local images (to free space):**
```bash
docker rmi subhaniuduwawala/lawpoint-backend:latest
docker rmi subhaniuduwawala/lawpoint-frontend:latest
```

**Pull images from Docker Hub:**
```bash
docker pull subhaniuduwawala/lawpoint-backend:latest
docker pull subhaniuduwawala/lawpoint-frontend:latest
```

---

## ⚠️ Troubleshooting

### Error: "denied: requested access to the resource is denied"

**Solution:** You're not logged in or wrong credentials
```bash
docker logout
docker login -u subhaniuduwawala
# Enter your Access Token when prompted
```

### Error: "unauthorized: incorrect username or password"

**Solution:** Use Access Token (not password)
1. Go to https://hub.docker.com/settings/security
2. Create New Access Token with "Read, Write, Delete" permissions
3. Use this token as password when logging in

### Error: "no such file or directory" when building

**Solution:** Make sure you're in the correct directory
```bash
# Check current directory
pwd

# Should be in: C:\Users\Asus\Documents\Project\LawPoint
cd C:\Users\Asus\Documents\Project\LawPoint
```

---

## 📝 What You Previously Did (for reference)

You already pushed images successfully with these commands:

```bash
docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

**Results:**
- Backend: sha256:0da7f034... (147MB)
- Frontend: sha256:d4e5aaca... (61.1MB)

Both are live on Docker Hub! ✅

---

## 🔗 Pushing Code to GitHub (Different from Docker)

If you want to push your **code** to GitHub (not Docker images):

```bash
# Stage all changes
git add .

# Commit with message
git commit -m "Update: Add Jenkins and Docker documentation"

# Push to GitHub
git push origin main
```

**Your GitHub repository:** https://github.com/Subhaniuduwawala/LawPoint

---

## Summary

| Action | Command |
|--------|---------|
| **Login** | `docker login -u subhaniuduwawala` |
| **Build Backend** | `docker build -t subhaniuduwawala/lawpoint-backend:latest ./backend` |
| **Build Frontend** | `docker build -t subhaniuduwawala/lawpoint-frontend:latest ./frontend` |
| **Push Backend** | `docker push subhaniuduwawala/lawpoint-backend:latest` |
| **Push Frontend** | `docker push subhaniuduwawala/lawpoint-frontend:latest` |
| **Verify** | Visit https://hub.docker.com/u/subhaniuduwawala |

---

**Need to rebuild and push again?** Just run:

```powershell
docker build -t subhaniuduwawala/lawpoint-backend:latest ./backend && docker push subhaniuduwawala/lawpoint-backend:latest
docker build -t subhaniuduwawala/lawpoint-frontend:latest ./frontend && docker push subhaniuduwawala/lawpoint-frontend:latest
```

Done! 🎉
