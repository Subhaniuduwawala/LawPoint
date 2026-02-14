# LawPoint - Legal Professional Directory

A full-stack web application that connects users with trusted legal professionals. Built with React, Node.js, Express, MongoDB, and deployed on AWS using a complete CI/CD DevOps pipeline.

---

## Deployed Links

| Service       | URL                                   |
| ------------- | ------------------------------------- |
| **Frontend**  | http://44.214.128.112:3000            |
| **Backend API** | http://44.214.128.112:4000          |
| **Health Check** | http://44.214.128.112:4000/api/health |
| **Docker Hub (Backend)** | https://hub.docker.com/r/subhaniuduwawala/lawpoint-backend |
| **Docker Hub (Frontend)** | https://hub.docker.com/r/subhaniuduwawala/lawpoint-frontend |

**SSH Access:**
```bash
ssh -i lawpoint-key.pem ec2-user@44.214.128.112
```

---

## Tech Stack

| Layer          | Technology                          |
| -------------- | ----------------------------------- |
| Frontend       | React 18, Vite, Axios, React Router |
| Backend        | Node.js, Express, Mongoose, JWT     |
| Database       | MongoDB 6.0                         |
| Containerization | Docker, Docker Compose            |
| CI/CD          | Jenkins                             |
| Infrastructure | Terraform (AWS)                     |
| Configuration  | Ansible                             |
| Cloud          | AWS EC2, VPC, Elastic IP            |

---

## Project Structure

```
LawPoint/
├── frontend/                # React frontend (Vite)
│   ├── Dockerfile           # Multi-stage build → Nginx
│   ├── nginx.conf           # Nginx config with API proxy
│   ├── vite.config.js       # Vite dev config
│   ├── package.json
│   ├── index.html
│   └── src/
│       ├── App.jsx          # Routes setup
│       ├── AuthContext.jsx   # Auth state management
│       ├── Login.jsx         # Login page
│       ├── Signup.jsx        # Signup page
│       ├── Lawyers.jsx       # Main lawyers directory page
│       ├── ProtectedRoute.jsx # Auth guard
│       ├── main.jsx          # Entry point
│       ├── *.css             # Stylesheets
│       └── images/           # Static images
│
├── backend/                 # Express.js API
│   ├── Dockerfile           # Node.js Alpine image
│   ├── server.js            # Main server with all routes
│   ├── seed.js              # Database seeder
│   ├── package.json
│   ├── middleware/
│   │   └── auth.js          # JWT authentication middleware
│   └── models/
│       ├── User.js           # User model (email, password, name)
│       └── Lawyer.js         # Lawyer model (name, specialty, location)
│
├── terraform/               # Infrastructure as Code
│   ├── main.tf              # AWS resources (VPC, EC2, SG, EIP)
│   ├── variables.tf         # Configurable variables
│   ├── outputs.tf           # Output values (IPs, URLs)
│   └── user_data.sh         # EC2 bootstrap script
│
├── ansible/                 # Configuration Management
│   ├── deploy.yml           # Deployment playbook
│   └── inventory.ini        # Server inventory
│
├── docker-compose.yml       # Local multi-container setup
├── Jenkinsfile              # CI/CD pipeline definition
└── .dockerignore            # Docker build exclusions
```

---

## API Endpoints

| Method | Endpoint             | Auth     | Description              |
| ------ | -------------------- | -------- | ------------------------ |
| GET    | `/api/health`        | No       | Health check             |
| POST   | `/api/auth/signup`   | No       | Register new user        |
| POST   | `/api/auth/login`    | No       | Login & get JWT token    |
| GET    | `/api/auth/me`       | Bearer   | Get current user profile |
| GET    | `/api/lawyers`       | No       | List all lawyers         |
| POST   | `/api/lawyers`       | Bearer   | Add a new lawyer         |

---

## Step-by-Step Setup Guide

### Prerequisites

- Node.js 18+
- Docker & Docker Compose
- Git
- AWS CLI (for deployment)
- Terraform (for infrastructure)

---

### Step 1: Clone the Repository

```bash
git clone <your-repo-url>
cd LawPoint
```

---

### Step 2: Run Locally with Docker Compose

```bash
# Start all services (MongoDB, Backend, Frontend)
docker compose up -d

# Check status
docker compose ps

# View logs
docker compose logs -f
```

**Access locally:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:4000
- Health Check: http://localhost:4000/api/health

---

### Step 3: Run Without Docker (Development)

**Start backend:**
```bash
cd backend
npm install
npm run dev
```

**Start frontend (in a new terminal):**
```bash
cd frontend
npm install
npm run dev
```

> Vite dev server auto-proxies `/api` requests to `http://localhost:4000`.

---

### Step 4: Seed the Database (Optional)

```bash
cd backend
node seed.js
```

---

### Step 5: Build Docker Images

```bash
# Build backend image
docker build -t subhaniuduwawala/lawpoint-backend:latest ./backend

# Build frontend image
docker build -t subhaniuduwawala/lawpoint-frontend:latest ./frontend
```

---

### Step 6: Push Images to Docker Hub

```bash
# Login to Docker Hub
docker login -u subhaniuduwawala

# Push images
docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest
```

---

### Step 7: Provision AWS Infrastructure with Terraform

```bash
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan -out=tfplan

# Apply infrastructure
terraform apply tfplan
```

**Resources created:**
- VPC with public subnet
- Internet Gateway & Route Table
- Security Group (ports: 22, 80, 443, 3000, 4000)
- EC2 instance (t3.medium, Ubuntu 22.04)
- Elastic IP: `44.214.128.112`

**Terraform outputs:**
```
frontend_url    = http://44.214.128.112:3000
backend_url     = http://44.214.128.112:4000
instance_id     = i-081261c63958b017d
instance_public_ip = 44.214.128.112
ssh_command     = ssh -i lawpoint-key.pem ec2-user@44.214.128.112
```

---

### Step 8: Deploy with Ansible (Alternative)

```bash
cd ansible

# Update inventory.ini with your server IP
# Then run:
ansible-playbook -i inventory.ini deploy.yml
```

This playbook:
1. Installs Docker & Docker Compose on the EC2 instance
2. Copies the `docker-compose.yml`
3. Pulls the Docker images from Docker Hub
4. Starts all containers
5. Verifies the deployment with a health check

---

### Step 9: CI/CD with Jenkins

The `Jenkinsfile` automates the full pipeline:

| Stage                  | Description                                    |
| ---------------------- | ---------------------------------------------- |
| Checkout               | Pulls latest code from Git                     |
| Setup Docker Buildx    | Configures Docker build environment            |
| Login to Docker Hub    | Authenticates with Docker Hub credentials      |
| Build Backend Image    | Builds backend Docker image with caching       |
| Build Frontend Image   | Builds frontend Docker image with caching      |
| Push Backend Image     | Pushes backend image (`:latest` + `:commit`)   |
| Push Frontend Image    | Pushes frontend image (`:latest` + `:commit`)  |
| Deploy to AWS          | SSHs into EC2, pulls images, restarts services |
| Health Check           | Verifies frontend & backend are responding     |

**Jenkins Credentials Required:**
- `dockerhub-credentials` — Docker Hub username/password
- `lawpoint-ssh-key` — EC2 SSH private key file

---

## Architecture Diagram

```
┌─────────────┐     ┌─────────────────────────────────────────────┐
│   Browser    │     │           AWS EC2 (44.214.128.112)          │
│             │     │                                             │
│  :3000 ────────────▶  Nginx (Frontend Container)                │
│             │     │    ├── Serves React SPA                     │
│             │     │    └── Proxies /api/* ──▶ Backend :4000     │
│             │     │                                             │
│             │     │         Express.js (Backend Container)      │
│             │     │          ├── REST API                       │
│             │     │          └── JWT Authentication             │
│             │     │                    │                        │
│             │     │         MongoDB Container (:27017)          │
│             │     │          └── lawpoint database              │
└─────────────┘     └─────────────────────────────────────────────┘

┌──────────────────────────────────────────────────┐
│                  CI/CD Pipeline                   │
│  Git Push → Jenkins → Build → Push → Deploy      │
│               Docker Hub ←──┘     └──▶ EC2       │
└──────────────────────────────────────────────────┘
```

---

## Environment Variables

| Variable     | Default                              | Description           |
| ------------ | ------------------------------------ | --------------------- |
| `PORT`       | `4000`                               | Backend server port   |
| `MONGO_URI`  | `mongodb://mongo:27017/lawpoint`     | MongoDB connection    |
| `JWT_SECRET` | `your-secret-key-change-in-production` | JWT signing secret  |

---

## Useful Commands

```bash
# Check running containers
docker compose ps

# View logs
docker compose logs -f backend
docker compose logs -f frontend

# Restart services
docker compose restart

# Rebuild and restart
docker compose down
docker compose up -d --build

# SSH into EC2
ssh -i lawpoint-key.pem ec2-user@44.214.128.112

# Destroy AWS infrastructure
cd terraform && terraform destroy
```

---

## License

MIT
