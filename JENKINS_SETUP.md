# Jenkins Pipeline Setup for LawPoint

This guide explains how to set up Jenkins to run the automated Docker build and push pipeline for the LawPoint project.

## Prerequisites

- Jenkins server installed and running
- Docker installed on Jenkins server (or Jenkins agent)
- Docker Hub account (subhaniuduwawala)
- GitHub repository: https://github.com/Subhaniuduwawala/LawPoint

## Jenkins Setup Steps

### 1. Install Required Jenkins Plugins

Go to **Manage Jenkins → Manage Plugins → Available** and install:

- ✅ **Docker Pipeline Plugin** - For Docker commands in pipeline
- ✅ **Docker Plugin** - For Docker integration
- ✅ **Git Plugin** - For Git repository integration
- ✅ **GitHub Plugin** - For GitHub webhooks
- ✅ **Credentials Binding Plugin** - For secure credential management
- ✅ **Pipeline Plugin** - For pipeline job support

### 2. Configure Docker Hub Credentials

1. Go to **Manage Jenkins → Manage Credentials**
2. Select **(global)** domain
3. Click **Add Credentials**
4. Fill in the form:
   - **Kind**: Username with password
   - **Scope**: Global
   - **Username**: `subhaniuduwawala`
   - **Password**: Your Docker Hub Access Token (with Read, Write, Delete permissions)
   - **ID**: `dockerhub-credentials` ⚠️ **IMPORTANT: Must match the ID in Jenkinsfile**
   - **Description**: Docker Hub credentials for LawPoint
5. Click **Create**

### 3. Create Jenkins Pipeline Job

1. Go to Jenkins dashboard
2. Click **New Item**
3. Enter name: `LawPoint-Docker-Build`
4. Select **Pipeline** job type
5. Click **OK**

### 4. Configure Pipeline Job

#### General Settings
- ✅ Check **GitHub project** (optional)
  - Project url: `https://github.com/Subhaniuduwawala/LawPoint/`

#### Build Triggers
Choose one or more:

**Option A: GitHub Webhook (Recommended)**
- ✅ Check **GitHub hook trigger for GITScm polling**
- This will trigger builds automatically when you push to GitHub

**Option B: Poll SCM**
- ✅ Check **Poll SCM**
- Schedule: `H/5 * * * *` (checks every 5 minutes)
- Less efficient than webhooks

**Option C: Manual Trigger**
- Leave triggers unchecked
- Build manually from Jenkins UI

#### Pipeline Configuration

1. **Definition**: Pipeline script from SCM
2. **SCM**: Git
3. **Repository URL**: `https://github.com/Subhaniuduwawala/LawPoint.git`
4. **Credentials**: Add GitHub credentials if repository is private
5. **Branch Specifier**: `*/main`
6. **Script Path**: `Jenkinsfile`
7. Click **Save**

### 5. Set Up GitHub Webhook (Optional but Recommended)

This enables automatic builds when you push code to GitHub.

1. Go to your GitHub repository: https://github.com/Subhaniuduwawala/LawPoint
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Fill in:
   - **Payload URL**: `http://YOUR_JENKINS_URL/github-webhook/`
     - Example: `http://jenkins.yourcompany.com:8080/github-webhook/`
   - **Content type**: `application/json`
   - **Which events**: Just the push event
   - ✅ Check **Active**
4. Click **Add webhook**

⚠️ **Note**: If Jenkins is running locally, you'll need to expose it using:
- ngrok: `ngrok http 8080`
- CloudFlare Tunnel
- Or deploy Jenkins to a cloud server

### 6. Run Your First Build

1. Go to the pipeline job: `LawPoint-Docker-Build`
2. Click **Build Now**
3. Watch the build progress in **Console Output**

## Pipeline Stages Explained

The Jenkins pipeline performs these stages:

```
1. Checkout          → Clone code from GitHub
2. Setup Buildx      → Configure Docker Buildx for multi-platform builds
3. Login to Docker   → Authenticate with Docker Hub
4. Build Backend     → Build backend Docker image (node:18-alpine)
5. Build Frontend    → Build frontend Docker image (nginx:alpine)
6. Push Backend      → Push backend images (latest + commit SHA)
7. Push Frontend     → Push frontend images (latest + commit SHA)
8. Summary           → Display pushed images
```

## Environment Variables

The pipeline uses these environment variables (configured in Jenkinsfile):

- `DOCKERHUB_CREDENTIALS` → Jenkins credential ID: dockerhub-credentials
- `DOCKERHUB_USERNAME` → subhaniuduwawala
- `BACKEND_IMAGE` → subhaniuduwawala/lawpoint-backend
- `FRONTEND_IMAGE` → subhaniuduwawala/lawpoint-frontend
- `GIT_COMMIT_SHORT` → Short commit SHA (e.g., a1b2c3d)

## Docker Image Tags

Each build pushes **2 tags per image**:

**Backend:**
- `subhaniuduwawala/lawpoint-backend:latest`
- `subhaniuduwawala/lawpoint-backend:<commit-sha>`

**Frontend:**
- `subhaniuduwawala/lawpoint-frontend:latest`
- `subhaniuduwawala/lawpoint-frontend:<commit-sha>`

## Comparing with GitHub Actions

| Feature | GitHub Actions | Jenkins |
|---------|---------------|---------|
| **Hosting** | GitHub cloud (free) | Self-hosted server |
| **Setup** | Workflow file only | Install + configure Jenkins |
| **Triggers** | Git push (automatic) | Webhook or polling |
| **Secrets** | GitHub Secrets UI | Jenkins Credentials |
| **Cost** | Free for public repos | Server hosting costs |
| **Control** | Limited | Full control |
| **Build History** | GitHub Actions tab | Jenkins UI |

## Troubleshooting

### Build Fails: "docker: command not found"

**Solution**: Install Docker on Jenkins server
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io

# Add Jenkins user to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Build Fails: "permission denied while trying to connect to Docker daemon"

**Solution**: Jenkins user needs Docker permissions
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Build Fails: "ERROR: Could not find credentials matching 'dockerhub-credentials'"

**Solution**: 
1. Check credential ID in Jenkins is exactly: `dockerhub-credentials`
2. Ensure credential has **Read, Write, Delete** permissions on Docker Hub
3. Recreate credential if needed

### GitHub Webhook Not Triggering Builds

**Solution**:
1. Check webhook delivery in GitHub Settings → Webhooks
2. Ensure Jenkins URL is accessible from internet
3. Check Jenkins logs: `/var/log/jenkins/jenkins.log`
4. Verify "GitHub hook trigger" is enabled in job configuration

### Build Slow or Times Out

**Solution**:
1. Enable Docker layer caching (already in Jenkinsfile)
2. Increase Jenkins executor timeout
3. Use faster Jenkins agent/server
4. Remove multi-platform build if not needed:
   ```groovy
   // Remove --platform flag for single architecture
   docker buildx build --tag ${IMAGE}:latest .
   ```

## Monitoring and Notifications

### Email Notifications

Add to `post` section in Jenkinsfile:

```groovy
post {
    success {
        emailext (
            subject: "✅ LawPoint Build Success - ${BUILD_NUMBER}",
            body: "Build completed successfully!\nImages pushed to Docker Hub.",
            to: "your-email@example.com"
        )
    }
    failure {
        emailext (
            subject: "❌ LawPoint Build Failed - ${BUILD_NUMBER}",
            body: "Build failed! Check: ${BUILD_URL}console",
            to: "your-email@example.com"
        )
    }
}
```

### Slack Notifications

Install **Slack Notification Plugin** and add:

```groovy
post {
    success {
        slackSend (
            color: 'good',
            message: "✅ LawPoint build ${BUILD_NUMBER} succeeded!"
        )
    }
}
```

## Next Steps

1. ✅ Set up Jenkins server (if not already done)
2. ✅ Install required plugins
3. ✅ Configure Docker Hub credentials
4. ✅ Create pipeline job
5. ✅ Set up GitHub webhook (optional)
6. ✅ Run first build
7. ✅ Verify images on Docker Hub
8. 🔄 Configure notifications (optional)
9. 🔄 Set up build badges (optional)

## Build Badge

Add to your README.md:

```markdown
![Jenkins Build](http://YOUR_JENKINS_URL/buildStatus/icon?job=LawPoint-Docker-Build)
```

## Useful Jenkins Commands

```bash
# Check Jenkins status
sudo systemctl status jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# View Jenkins logs
sudo tail -f /var/log/jenkins/jenkins.log

# Check Docker access
sudo -u jenkins docker ps
```

## Security Best Practices

1. ✅ Use Jenkins credentials system (never hardcode secrets)
2. ✅ Use Docker Hub Access Tokens (not password)
3. ✅ Enable HTTPS for Jenkins
4. ✅ Restrict Jenkins access with authentication
5. ✅ Keep Jenkins and plugins updated
6. ✅ Use separate credentials per project
7. ✅ Rotate access tokens regularly

## Resources

- **Jenkins Documentation**: https://www.jenkins.io/doc/
- **Docker Pipeline Plugin**: https://plugins.jenkins.io/docker-workflow/
- **GitHub Integration**: https://plugins.jenkins.io/github/
- **Pipeline Syntax**: https://www.jenkins.io/doc/book/pipeline/syntax/

---

**Need Help?**
- Check Jenkins console output for detailed error messages
- Review Docker Hub token permissions
- Verify GitHub repository access
- Check Jenkins and Docker logs
