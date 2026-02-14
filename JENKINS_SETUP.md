# Jenkins Setup Guide for LawPoint

This guide explains how to configure Jenkins to run the LawPoint CI/CD pipeline.

---

## Prerequisites

- Jenkins installed and running on port 8080
- Docker installed on the Jenkins server
- Access to Docker Hub
- SSH access to AWS EC2 instance

---

## Required Jenkins Credentials

Configure these credentials in Jenkins: **Manage Jenkins → Credentials → System → Global credentials**

### 1. Docker Hub Credentials
- **Credential ID**: `dockerhub-credentials`
- **Type**: Username with password
- **Username**: `subhaniuduwawala`
- **Password**: Your Docker Hub access token (NOT your Docker Hub password)
  
**To create a Docker Hub access token:**
1. Go to https://hub.docker.com/settings/security
2. Click "New Access Token"
3. Name it "Jenkins LawPoint"
4. Copy the token and use it as the password in Jenkins

### 2. SSH Key for AWS
- **Credential ID**: `lawpoint-ssh-key`
- **Type**: Secret file
- **File**: Upload your `lawpoint-key.pem` file

**Location of SSH key**: The private key used to create the EC2 instance

---

## Required Jenkins Plugins

Install these plugins from **Manage Jenkins → Plugins**:

1. **Docker Pipeline** - For Docker commands in pipeline
2. **Git** - For checking out code
3. **Pipeline** - For running Jenkinsfile
4. **Credentials Binding** - For using credentials in pipeline
5. **SSH Agent** (optional) - For better SSH handling

---

## Jenkins Pipeline Configuration

### Create a New Pipeline Job

1. **Go to Jenkins Dashboard** → Click "New Item"
2. **Enter name**: `LawPoint-CI-CD`
3. **Select**: Pipeline
4. **Click**: OK

### Configure the Pipeline

In the pipeline configuration:

1. **General Section**:
   - ☑ GitHub project
   - Project URL: `https://github.com/Subhaniuduwawala/LawPoint/`

2. **Build Triggers**:
   - ☑ GitHub hook trigger for GITScm polling (for automatic builds on push)
   - OR ☑ Poll SCM with schedule: `H/5 * * * *` (checks every 5 minutes)

3. **Pipeline Section**:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `https://github.com/Subhaniuduwawala/LawPoint.git`
   - Credentials: (add GitHub credentials if private repo)
   - Branch Specifier: `*/main`
   - Script Path: `Jenkinsfile`

4. **Click**: Save

---

## GitHub Webhook Configuration (Optional but Recommended)

To trigger Jenkins builds automatically on code push:

1. Go to your GitHub repository
2. Navigate to **Settings → Webhooks → Add webhook**
3. **Payload URL**: `http://YOUR_JENKINS_URL:8080/github-webhook/`
4. **Content type**: `application/json`
5. **Which events**: Just the push event
6. **Active**: ☑ Checked
7. Click: **Add webhook**

---

## Jenkinsfile Overview

The pipeline has 9 stages:

| Stage | Description |
|-------|-------------|
| 1. Checkout | Pulls latest code from Git |
| 2. Setup Docker Buildx | Configures Docker build environment |
| 3. Login to Docker Hub | Authenticates with Docker Hub |
| 4. Build Backend Image | Builds backend Docker image |
| 5. Build Frontend Image | Builds frontend Docker image |
| 6. Push Backend Image | Pushes backend to Docker Hub |
| 7. Push Frontend Image | Pushes frontend to Docker Hub |
| 8. Deploy to AWS | SSHs to EC2 and updates containers (main branch only) |
| 9. Health Check | Verifies deployment is working (main branch only) |

---

## Testing the Pipeline

### Manual Test Run

1. Go to the pipeline job
2. Click **Build Now**
3. Watch the console output for any errors

### Expected Output

```
✅ Pipeline completed successfully!
Images pushed to Docker Hub: https://hub.docker.com/u/subhaniuduwawala
🚀 Application deployed to: http://44.214.128.112:3000
📊 Backend API: http://44.214.128.112:4000
```

---

## Common Issues and Fixes

### Issue 1: "dockerhub-credentials not found"

**Fix**: Create the Docker Hub credential with ID `dockerhub-credentials`

```
Manage Jenkins → Credentials → System → Global credentials → Add Credentials
- Kind: Username with password
- Username: subhaniuduwawala
- Password: [Your Docker Hub Access Token]
- ID: dockerhub-credentials
```

### Issue 2: "lawpoint-ssh-key not found"

**Fix**: Upload the SSH key file

```
Manage Jenkins → Credentials → System → Global credentials → Add Credentials
- Kind: Secret file
- File: Upload lawpoint-key.pem
- ID: lawpoint-ssh-key
```

### Issue 3: "Permission denied (publickey)" when deploying

**Causes**:
1. Wrong SSH key uploaded
2. Key doesn't have correct permissions
3. Key doesn't match the EC2 instance

**Fix**:
1. Verify the key file is correct
2. Check the key permissions locally: `chmod 400 lawpoint-key.pem`
3. Test SSH manually: `ssh -i lawpoint-key.pem ubuntu@44.214.128.112`

### Issue 4: "docker: command not found" on Jenkins

**Fix**: Install Docker on the Jenkins server

```bash
# On Jenkins server
sudo apt-get update
sudo apt-get install -y docker.io
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue 5: Build fails on "docker buildx"

**Fix**: Install Docker Buildx plugin

```bash
# On Jenkins server
docker buildx version || {
  docker buildx create --use --name mybuilder
  docker buildx inspect --bootstrap
}
```

### Issue 6: Health check fails after deployment

**Possible causes**:
1. Containers not fully started (wait longer)
2. EC2 instance security group blocking ports
3. Docker Compose not running on EC2

**Fix**:
1. Increase sleep time in health check stage
2. Verify security group allows ports 3000, 4000
3. SSH to EC2 and run `docker compose ps` to check containers

---

## Environment Variables in Jenkinsfile

The pipeline uses these environment variables:

| Variable | Value | Description |
|----------|-------|-------------|
| `DOCKERHUB_USERNAME` | `subhaniuduwawala` | Docker Hub username |
| `BACKEND_IMAGE` | `subhaniuduwawala/lawpoint-backend` | Backend image name |
| `FRONTEND_IMAGE` | `subhaniuduwawala/lawpoint-frontend` | Frontend image name |
| `SERVER_IP` | `44.214.128.112` | AWS EC2 public IP |
| `GIT_COMMIT_SHORT` | (auto) | Short Git commit hash |

---

## Deployment Path on EC2

The pipeline deploys to: `/home/ubuntu/lawpoint/`

This directory must contain:
- `docker-compose.yml` (automatically pulled with the images)

---

## Manual Deployment (Without Jenkins)

If Jenkins is not working, you can deploy manually:

```bash
# 1. Build and push images
cd /path/to/LawPoint
docker build -t subhaniuduwawala/lawpoint-backend:latest ./backend
docker build -t subhaniuduwawala/lawpoint-frontend:latest ./frontend
docker push subhaniuduwawala/lawpoint-backend:latest
docker push subhaniuduwawala/lawpoint-frontend:latest

# 2. Deploy to AWS
ssh -i lawpoint-key.pem ubuntu@44.214.128.112
cd /home/ubuntu/lawpoint
docker compose pull
docker compose up -d
docker compose ps
```

---

## Monitoring Jenkins

### View Build History
- Go to pipeline job → Build History (left sidebar)
- Click on any build number → Console Output

### View Logs
```bash
# On Jenkins server
sudo tail -f /var/log/jenkins/jenkins.log
```

### Check Docker on Jenkins Server
```bash
docker ps
docker images
docker system df  # Check disk usage
```

---

## Security Best Practices

1. **Never commit sensitive data** to Git:
   - SSH private keys
   - Docker Hub passwords
   - AWS credentials

2. **Use Jenkins credentials store** for all secrets

3. **Restrict Jenkins access**:
   - Enable authentication
   - Set up user roles
   - Use HTTPS (recommended)

4. **Rotate credentials regularly**:
   - Docker Hub access tokens
   - SSH keys
   - Jenkins passwords

---

## Troubleshooting Checklist

Before running a build, verify:

- [ ] Jenkins is running and accessible
- [ ] Docker Hub credentials are configured
- [ ] SSH key is uploaded to Jenkins
- [ ] EC2 instance is running (AWS console)
- [ ] Security groups allow ports 22, 3000, 4000, 8080
- [ ] Docker is installed on Jenkins server
- [ ] Git repository is accessible
- [ ] Main branch has latest code

---

## Getting Help

If builds fail:

1. **Check Console Output**: Click on build number → Console Output
2. **Verify Credentials**: Manage Jenkins → Credentials
3. **Test Components Individually**:
   - Test Docker: `docker ps`
   - Test SSH: `ssh -i key.pem ubuntu@44.214.128.112`
   - Test Docker Hub: `docker login`
4. **Check EC2 Instance**: SSH to server and run `docker compose ps`

---

## Additional Resources

- Jenkins Documentation: https://www.jenkins.io/doc/
- Docker Pipeline Plugin: https://plugins.jenkins.io/docker-workflow/
- GitHub Webhooks: https://docs.github.com/en/webhooks
- Docker Hub: https://hub.docker.com/u/subhaniuduwawala
