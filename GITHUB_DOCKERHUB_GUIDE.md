# GitHub & Docker Hub Setup Guide

## ✅ COMPLETED:
- ✅ Docker images built
- ✅ Pushed to Docker Hub: 
  - `subhaniuduwawala/lawpoint-backend:latest`
  - `subhaniuduwawala/lawpoint-frontend:latest`
- ✅ Git repository initialized
- ✅ All files committed
- ✅ GitHub Actions workflow created

---

## 🔑 Step 1: Get GitHub Personal Access Token

You need a Personal Access Token to push to GitHub:

1. **Go to:** https://github.com/settings/tokens
2. **Click:** "Generate new token (classic)"
3. **Note:** "LawPoint Push Token"
4. **Expiration:** Choose "90 days" or "No expiration"
5. **Select scopes:**
   - ✅ `repo` (all checkboxes) - Full control of private repositories
   - ✅ `workflow` - Update GitHub Action workflows
6. **Click:** "Generate token"
7. **COPY THE TOKEN** - You won't see it again!

---

## 📤 Step 2: Push to GitHub

### Option A: Using WSL (Recommended)
```bash
wsl
cd /mnt/c/Users/Asus/Documents/Project/LawPoint

# Push to GitHub
git push -u origin main
# Username: Subhaniuduwawala
# Password: [PASTE YOUR PERSONAL ACCESS TOKEN]
```

### Option B: Using Git Credential Manager
```bash
wsl
cd /mnt/c/Users/Asus/Documents/Project/LawPoint

# Store credentials
git config credential.helper store

# Push
git push -u origin main
# Enter your token when prompted
```

---

## 🔐 Step 3: Set Up GitHub Secrets for CI/CD

For GitHub Actions to automatically build and push images, add these secrets:

1. **Go to your repo:** https://github.com/Subhaniuduwawala/LawPoint
2. **Click:** Settings → Secrets and variables → Actions
3. **Click:** "New repository secret"

**Add these 2 secrets:**

### Secret 1: DOCKERHUB_USERNAME
- **Name:** `DOCKERHUB_USERNAME`
- **Value:** `subhaniuduwawala`

### Secret 2: DOCKERHUB_TOKEN
- **Name:** `DOCKERHUB_TOKEN`
- **Value:** [Your Docker Hub Access Token]

**To get Docker Hub token:**
1. Go to: https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Description: "GitHub Actions"
4. Access permissions: Read, Write, Delete
5. Generate and copy the token

---

## 🚀 Step 4: Test GitHub Actions

After pushing to GitHub and adding secrets:

1. **Go to:** https://github.com/Subhaniuduwawala/LawPoint/actions
2. **Click:** "Build and Push Docker Images" workflow
3. **Click:** "Run workflow" → "Run workflow"
4. **Watch** the build process!

GitHub will automatically:
- ✅ Build backend Docker image
- ✅ Build frontend Docker image
- ✅ Push both images to Docker Hub
- ✅ Tag with `latest` and commit SHA

---

## 🔄 Automatic Builds

Your workflow will now automatically run when you:
- Push to the `main` branch
- Create a pull request to `main`
- Manually trigger it from Actions tab

---

## 📝 Quick Commands Reference

### Push Code to GitHub
```bash
cd /mnt/c/Users/Asus/Documents/Project/LawPoint
git add .
git commit -m "Your commit message"
git push
```

### Pull Latest Code
```bash
git pull origin main
```

### Check GitHub Actions Status
```bash
# In browser
https://github.com/Subhaniuduwawala/LawPoint/actions
```

### Pull Your Images on Any Machine
```bash
docker pull subhaniuduwawala/lawpoint-backend:latest
docker pull subhaniuduwawala/lawpoint-frontend:latest
docker compose up
```

---

## 🎯 What You Have Now

✅ **Docker Images on Docker Hub**
   - Backend: https://hub.docker.com/r/subhaniuduwawala/lawpoint-backend
   - Frontend: https://hub.docker.com/r/subhaniuduwawala/lawpoint-frontend

✅ **GitHub Repository**
   - Code: https://github.com/Subhaniuduwawala/LawPoint
   - Actions: https://github.com/Subhaniuduwawala/LawPoint/actions

✅ **CI/CD Pipeline**
   - Automatically builds on every push
   - Automatically pushes to Docker Hub
   - Tags images with commit SHA for version tracking

---

## 🆘 Troubleshooting

### "Authentication failed" when pushing to GitHub
- Make sure you're using a Personal Access Token, not your password
- The token must have `repo` scope enabled

### GitHub Actions failing
- Check if Docker Hub secrets are added correctly
- Verify secret names are exactly: `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`

### Can't find workflow in Actions tab
- Make sure you pushed the `.github/workflows/docker-build.yml` file
- Check the workflow file syntax is correct

---

## 🎉 Success Criteria

You're done when:
- ✅ Code is on GitHub: https://github.com/Subhaniuduwawala/LawPoint
- ✅ Images are on Docker Hub
- ✅ GitHub Actions shows green checkmarks
- ✅ Anyone can run: `docker pull subhaniuduwawala/lawpoint-backend:latest`
- ✅ Anyone can clone and run: `git clone ... && docker compose up`

---

## 📚 Next Steps (Optional)

1. **Add README badges:**
   ```markdown
   ![Docker Build](https://github.com/Subhaniuduwawala/LawPoint/actions/workflows/docker-build.yml/badge.svg)
   ![Docker Pulls](https://img.shields.io/docker/pulls/subhaniuduwawala/lawpoint-backend)
   ```

2. **Add versioning:**
   - Tag releases: `git tag v1.0.0 && git push --tags`
   - Update workflow to build version tags

3. **Deploy to cloud:**
   - AWS ECS, Azure Container Instances, or Heroku
   - Update GitHub Actions to auto-deploy

4. **Add tests:**
   - Run tests in GitHub Actions before building
   - Only push images if tests pass

Good luck! 🚀
