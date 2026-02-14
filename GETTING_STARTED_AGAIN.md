# 🔄 Getting Started Again - LawPoint Project

Welcome back! Here's everything you need to remember and continue your project.

---

## 📌 QUICK SUMMARY - What You Built

**LawPoint** is a lawyer directory web application with:
- **Frontend**: React (Vite) - Port 3000
- **Backend**: Node.js + Express - Port 4000  
- **Database**: MongoDB - Port 27017
- **Authentication**: JWT-based signup/login
- **CI/CD**: Jenkins pipeline + GitHub Actions
- **Containerization**: Docker + Docker Compose
- **Registry**: Docker Hub (subhaniuduwawala)

**Repository**: https://github.com/Subhaniuduwawala/LawPoint

---

## 🚀 STEP 1: ACCESS JENKINS

### Option A: If Jenkins is Running Locally

1. **Open Jenkins in Browser**:
   ```
   http://localhost:8080
   ```

2. **Login Credentials**:
   - You set these up when you installed Jenkins
   - Default username is usually: `admin`
   - If you forgot password, see "Forgot Jenkins Password" section below

### Option B: If Jenkins is NOT Running

1. **Check if Jenkins is Running**:
   ```powershell
   # Check Jenkins service status
   Get-Service -Name Jenkins*
   
   # OR check if port 8080 is in use
   netstat -ano | findstr :8080
   ```

2. **Start Jenkins**:
   
   **Windows Service (if installed as service)**:
   ```powershell
   # Start Jenkins service
   Start-Service -Name Jenkins
   
   # OR using Services GUI
   services.msc  # Find "Jenkins" and click Start
   ```
   
   **Standalone Jenkins (if using jenkins.war)**:
   ```powershell
   # Navigate to Jenkins directory
   cd C:\path\to\jenkins
   
   # Start Jenkins
   java -jar jenkins.war --httpPort=8080
   ```

3. **Access Jenkins**:
   ```
   http://localhost:8080
   ```

### 🔐 Forgot Jenkins Password?

**Method 1: Reset via config.xml**

1. **Stop Jenkins**:
   ```powershell
   Stop-Service -Name Jenkins
   ```

2. **Edit config.xml**:
   ```powershell
   # Find Jenkins home (usually)
   cd C:\Users\Asus\.jenkins
   
   # OR
   cd C:\Program Files\Jenkins
   
   # Edit config.xml
   notepad config.xml
   ```

3. **Disable Security** (temporarily):
   - Find: `<useSecurity>true</useSecurity>`
   - Change to: `<useSecurity>false</useSecurity>`
   - Save and close

4. **Start Jenkins**:
   ```powershell
   Start-Service -Name Jenkins
   ```

5. **Reset Password**:
   - Go to: http://localhost:8080
   - Navigate to: **Manage Jenkins → Manage Users**
   - Click on your username → **Configure**
   - Enter new password → Save

6. **Re-enable Security**:
   - Change `<useSecurity>false</useSecurity>` back to `true`
   - Restart Jenkins

**Method 2: Get Initial Admin Password** (if first time):
```powershell
# Windows
Get-Content "C:\Users\Asus\.jenkins\secrets\initialAdminPassword"

# OR
type C:\Program Files\Jenkins\secrets\initialAdminPassword
```

---

## 🛠️ STEP 2: CHECK YOUR JENKINS PIPELINE

1. **Login to Jenkins**: http://localhost:8080

2. **Find Your Job**:
   - Look for job named: **`LawPoint-Docker-Build`** or **`LawPoint`**
   - If you don't see it, you may need to create it (see Step 5)

3. **View Pipeline Configuration**:
   - Click on the job name
   - Click **Configure** to see settings
   - Your Jenkinsfile is already in your GitHub repo!

4. **Run a Build**:
   - Click **Build Now**
   - Watch **Console Output** to see progress

---

## 💻 STEP 3: CHECK YOUR LOCAL ENVIRONMENT

### Check Docker

```powershell
# Check if Docker is running (in WSL)
wsl docker --version

# Check Docker images you built
wsl docker images | grep lawpoint

# Check if containers are running
wsl docker ps
```

### Check MongoDB

```powershell
# Check if MongoDB is running (Windows service)
Get-Service -Name MongoDB*

# OR check connection
wsl mongo --version
```

### Check Node.js

```powershell
# Check Node version
node --version

# Should show: v22.19.0 or similar
```

---

## 🐳 STEP 4: RUN YOUR APPLICATION LOCALLY

### Using Docker Compose (Recommended)

```powershell
# Navigate to project
cd C:\Users\Asus\Documents\Project\LawPoint

# Start all containers (MongoDB, Backend, Frontend)
wsl docker compose up -d

# Check status
wsl docker compose ps

# View logs
wsl docker compose logs -f

# Access application
# Frontend: http://localhost:3000
# Backend: http://localhost:4000
```

### Stop Containers

```powershell
# Stop all containers
wsl docker compose down

# Stop and remove volumes (database data)
wsl docker compose down -v
```

### Using npm (Development Mode)

**Terminal 1 - Backend**:
```powershell
cd backend
npm install
npm run dev
# Runs on: http://localhost:4000
```

**Terminal 2 - Frontend**:
```powershell
cd frontend
npm install
npm run dev
# Runs on: http://localhost:3000
```

**Terminal 3 - MongoDB** (if not running as service):
```powershell
# Check if MongoDB is already running
Get-Service -Name MongoDB

# If not, start it
Start-Service -Name MongoDB
```

---

## 🔧 STEP 5: SETUP JENKINS JOB (If Not Created Yet)

### Create Jenkins Pipeline Job

1. **Login to Jenkins**: http://localhost:8080

2. **Create New Job**:
   - Click **New Item**
   - Name: `LawPoint-Docker-Build`
   - Type: **Pipeline**
   - Click **OK**

3. **Configure Job**:
   
   **General**:
   - ✅ GitHub project
   - URL: `https://github.com/Subhaniuduwawala/LawPoint/`

   **Build Triggers**:
   - ✅ GitHub hook trigger for GITScm polling (for automatic builds)
   - OR ✅ Poll SCM: `H/5 * * * *` (check every 5 minutes)

   **Pipeline**:
   - Definition: **Pipeline script from SCM**
   - SCM: **Git**
   - Repository URL: `https://github.com/Subhaniuduwawala/LawPoint.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

4. **Add Docker Hub Credentials**:
   - Go to: **Manage Jenkins → Manage Credentials**
   - Domain: **(global)**
   - Click **Add Credentials**
   - Kind: **Username with password**
   - Username: `subhaniuduwawala`
   - Password: Your Docker Hub Access Token (create at: https://hub.docker.com/settings/security)
   - ID: `dockerhub-credentials` ⚠️ **MUST BE EXACTLY THIS**
   - Description: `Docker Hub for LawPoint`
   - Click **Create**

5. **Save and Build**:
   - Click **Save**
   - Click **Build Now**
   - Check **Console Output**

---

## 📊 STEP 6: VERIFY EVERYTHING WORKS

### Checklist

- [ ] Jenkins is running (http://localhost:8080)
- [ ] Can login to Jenkins
- [ ] Jenkins job exists: `LawPoint-Docker-Build`
- [ ] Docker Hub credentials are configured in Jenkins
- [ ] Docker is running in WSL
- [ ] Application runs locally with `docker compose up`
- [ ] Frontend accessible: http://localhost:3000
- [ ] Backend accessible: http://localhost:4000/api/lawyers
- [ ] MongoDB is running
- [ ] Can signup/login in the application
- [ ] Jenkins build succeeds (green ✅)
- [ ] Images pushed to Docker Hub successfully

---

## 🎯 WHAT TO DO NEXT

### Current State Analysis

Based on your project, here's what's complete and what's pending:

**✅ COMPLETED**:
- Full-stack application (React + Node.js + MongoDB)
- JWT authentication (signup/login)
- Docker images (backend & frontend)
- Docker Compose configuration
- Jenkins pipeline (Jenkinsfile)
- GitHub Actions workflow
- Images on Docker Hub

**⚠️ INCOMPLETE/TODO**:
- Terraform for infrastructure provisioning
- Ansible for configuration management
- Deployment to AWS EC2 or cloud platform
- CI/CD diagram documentation
- Production environment setup
- Kubernetes orchestration (optional)

### Recommended Next Steps

**If Preparing for Assignment/Project Submission**:

1. **Create CI/CD Diagram** (you mentioned this):
   - Use draw.io, Lucidchart, or PlantUML
   - Include: GitHub → Jenkins → Docker Hub → Deployment
   - Show container connectivity (Frontend → Backend → MongoDB)

2. **Add Terraform** (Infrastructure as Code):
   - Create `terraform/` directory
   - Write AWS EC2 infrastructure code
   - Provision VMs for Docker deployment

3. **Add Ansible** (Configuration Management):
   - Create `ansible/` directory
   - Write playbooks to install Docker
   - Automate deployment to servers

4. **Document Everything**:
   - Update README.md
   - Add architecture diagrams
   - Write deployment instructions

**If Continuing Development**:

1. **Test Application Thoroughly**:
   - Test all CRUD operations
   - Verify authentication works
   - Check database persistence

2. **Add More Features**:
   - Search lawyers by specialty
   - Lawyer profiles with images
   - Reviews and ratings
   - Contact form

3. **Deploy to Cloud**:
   - AWS EC2 with Docker Compose
   - AWS ECS (Elastic Container Service)
   - DigitalOcean Droplet
   - Heroku or Render

---

## 🆘 COMMON ISSUES & SOLUTIONS

### Issue 1: Jenkins Login Not Working

**Solution**: Reset password using config.xml method above

### Issue 2: Docker Build Fails in Jenkins

**Error**: `unauthorized: incorrect username or password`

**Solution**:
1. Go to https://hub.docker.com/settings/security
2. Create new Access Token with **Read, Write, Delete** permissions
3. Update Jenkins credentials with new token

### Issue 3: Port Already in Use

**Error**: `Port 3000/4000/27017 already in use`

**Solution**:
```powershell
# Find process using port
netstat -ano | findstr :3000

# Kill process (replace PID)
taskkill /PID <PID> /F

# OR use docker compose
wsl docker compose down
```

### Issue 4: Cannot Access MongoDB

**Solution**:
```powershell
# Start MongoDB service
Start-Service -Name MongoDB

# Check status
Get-Service -Name MongoDB
```

### Issue 5: WSL Docker Not Working

**Solution**:
```powershell
# Start WSL
wsl

# Check Docker in WSL
docker --version

# Start Docker daemon (if needed)
sudo service docker start
```

---

## 📱 QUICK REFERENCE - Important URLs

| Service | URL | Credentials |
|---------|-----|-------------|
| **Frontend** | http://localhost:3000 | Signup on the app |
| **Backend API** | http://localhost:4000/api/lawyers | N/A |
| **Jenkins** | http://localhost:8080 | Your Jenkins user |
| **Docker Hub** | https://hub.docker.com/u/subhaniuduwawala | subhaniuduwawala |
| **GitHub Repo** | https://github.com/Subhaniuduwawala/LawPoint | Your GitHub account |
| **MongoDB** | mongodb://localhost:27017 | No auth (local) |

---

## 📞 QUICK COMMANDS CHEAT SHEET

```powershell
# ===== DOCKER =====
wsl docker compose up -d              # Start all containers
wsl docker compose down               # Stop all containers
wsl docker compose logs -f            # View logs
wsl docker ps                         # List running containers
wsl docker images                     # List images

# ===== GIT =====
git status                            # Check changes
git pull origin main                  # Get latest code
git add .                             # Stage changes
git commit -m "message"               # Commit
git push origin main                  # Push to GitHub

# ===== NPM =====
npm install                           # Install dependencies
npm run dev                           # Start dev server
npm run build                         # Build for production

# ===== JENKINS =====
Start-Service -Name Jenkins           # Start Jenkins
Stop-Service -Name Jenkins            # Stop Jenkins
Get-Service -Name Jenkins             # Check status

# ===== MONGODB =====
Start-Service -Name MongoDB           # Start MongoDB
Get-Service -Name MongoDB             # Check status
```

---

## 🎓 YOUR PROJECT FOR ASSIGNMENT

Based on your requirements, here's what you need:

1. **CI/CD Design Diagram** - Draw and explain:
   - Git (GitHub) → Jenkins → Docker Hub
   - Terraform → AWS EC2 → Docker → Containers
   - Container connectivity (Frontend ↔ Backend ↔ MongoDB)

2. **Jenkins Pipeline** - ✅ Already have (Jenkinsfile)

3. **Terraform** - Need to add

4. **Ansible** - Need to add (optional)

5. **Docker/Kubernetes** - ✅ Have Docker, can add Kubernetes

6. **Documentation** - Need comprehensive explanation

---

**Need more help?** Check specific documentation files:
- `Jenkinsfile` - Your CI/CD pipeline
- `docker-compose.yml` - Container orchestration
- `DOCKER_PUSH_COMMANDS.md` - Docker Hub commands
- `.github/workflows/docker-build.yml` - GitHub Actions pipeline

Good luck continuing your project! 🚀
