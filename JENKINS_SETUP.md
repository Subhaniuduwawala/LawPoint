# Jenkins Setup and Configuration Guide

## Step 1: Install Jenkins on EC2

SSH into your EC2 server:
```bash
ssh -i lawpoint-key.pem ubuntu@44.214.128.112
```

### Install Java and Jenkins

```bash
# Update system
sudo apt update

# Install Java 17 (required for Jenkins)
sudo apt install -y openjdk-17-jdk

# Add Jenkins repository
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins
sudo apt update
sudo apt install -y jenkins

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins

# Check status
sudo systemctl status jenkins
```

### Get Initial Admin Password

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

**Copy this password** — you'll need it to unlock Jenkins.

---

## Step 2: Access Jenkins

Open in browser:
```
http://44.214.128.112:8080
```

1. **Unlock Jenkins:** Paste the initial admin password
2. **Install Suggested Plugins:** Click "Install suggested plugins"
3. **Create First Admin User:** Fill in your details
4. **Jenkins URL:** Set to `http://44.214.128.112:8080`

---

## Step 3: Install Required Plugins

Go to **Manage Jenkins** → **Manage Plugins** → **Available**

Install these plugins:
- ✅ **Git Plugin** (should already be installed)
- ✅ **GitHub Integration Plugin**
- ✅ **Docker Plugin**
- ✅ **Docker Pipeline Plugin**
- ✅ **Pipeline Plugin**

Click **Install without restart**

---

## Step 4: Configure Git in Jenkins

### Method A: Configure Git Tool

1. Go to **Manage Jenkins** → **Global Tool Configuration**
2. Scroll to **Git** section
3. Click **Add Git**
   - **Name:** `Default`
   - **Path to Git executable:** `/usr/bin/git`
4. Click **Save**

### Method B: Ensure Jenkins User Can Access Git

```bash
# Switch to jenkins user
sudo su - jenkins -s /bin/bash

# Verify git works
git --version

# Exit jenkins user
exit
```

---

## Step 5: Add Credentials

### Docker Hub Credentials

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Click **(global)** → **Add Credentials**
3. Select **Username with password**
   - **Username:** `subhaniuduwawala`
   - **Password:** Your Docker Hub password or access token
   - **ID:** `dockerhub-credentials`
   - **Description:** Docker Hub
4. Click **Create**

### SSH Key for EC2 Deployment

1. On your EC2 server, generate or copy your SSH key:
```bash
cat ~/.ssh/lawpoint-key.pem
# Copy the entire content
```

2. In Jenkins: **Manage Jenkins** → **Manage Credentials** → **Add Credentials**
3. Select **SSH Username with private key**
   - **ID:** `lawpoint-ssh-key`
   - **Username:** `ubuntu`
   - **Private Key:** Click "Enter directly" and paste the key
   - **Description:** LawPoint EC2 SSH Key
4. Click **Create**

---

## Step 6: Create Pipeline Job

1. Click **New Item**
2. Enter name: `LawPoint-Pipeline`
3. Select **Pipeline**
4. Click **OK**

### Configure the Pipeline

**General:**
- ✅ Check **GitHub project**
  - **Project url:** `https://github.com/Subhaniuduwawala/LawPoint/`

**Build Triggers:**
- ✅ Check **GitHub hook trigger for GITScm polling**

**Pipeline:**
- **Definition:** Pipeline script from SCM
- **SCM:** Git
- **Repository URL:** `https://github.com/Subhaniuduwawala/LawPoint.git`
- **Credentials:** (leave as none for public repo)
- **Branches to build:** `*/main`
- **Script Path:** `Jenkinsfile`

Click **Save**

---

## Step 7: Configure GitHub Webhook

### Get Your Jenkins URL
Your webhook URL:
```
http://44.214.128.112:8080/github-webhook/
```

### Add Webhook to GitHub

1. Go to: https://github.com/Subhaniuduwawala/LawPoint/settings/hooks
2. Click **Add webhook**
3. Configure:
   - **Payload URL:** `http://44.214.128.112:8080/github-webhook/`
   - **Content type:** `application/json`
   - **Which events?** Select "Just the push event"
   - ✅ **Active**
4. Click **Add webhook**

### Verify Webhook
- GitHub should show a green checkmark ✅ after testing
- If red ❌, check:
  - Jenkins is accessible at port 8080
  - Security group allows port 8080
  - Webhook URL is correct

---

## Step 8: Fix Security Group for Jenkins

Add port 8080 to your EC2 security group:

```bash
aws ec2 authorize-security-group-ingress \
    --group-id sg-0740dbc10c702173c \
    --protocol tcp \
    --port 8080 \
    --cidr 0.0.0.0/0
```

Or manually in AWS Console:
1. Go to EC2 → Security Groups
2. Select `lawpoint-security-group`
3. Edit inbound rules
4. Add rule:
   - **Type:** Custom TCP
   - **Port:** 8080
   - **Source:** 0.0.0.0/0
   - **Description:** Jenkins

---

## Step 9: Test the Pipeline

### Manual Test
1. Go to your Jenkins job
2. Click **Build Now**
3. Check console output

### Auto-Trigger Test
```bash
# Make a small change
echo "test" >> test.txt
git add test.txt
git commit -m "test Jenkins auto-trigger"
git push origin main
```

Jenkins should start building within 10 seconds!

---

## Troubleshooting

### Git Error in Jenkins

**Error:** `Cannot run program "git"`

**Fix:**
```bash
# On EC2 server
sudo systemctl restart jenkins

# Or configure Git path in Jenkins
# Manage Jenkins → Global Tool Configuration → Git
# Set path to: /usr/bin/git
```

### Permission Issues

```bash
# Give Jenkins user docker permissions
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Webhook Not Working

1. **Check Jenkins log:**
```bash
sudo tail -f /var/log/jenkins/jenkins.log
```

2. **Test webhook endpoint:**
```bash
curl -X POST http://44.214.128.112:8080/github-webhook/
```

3. **Check GitHub webhook deliveries:**
   - Go to webhook settings
   - Check "Recent Deliveries" tab
   - Look for 200 OK response

### Pipeline Fails at Docker Commands

```bash
# Ensure Docker is installed
docker --version

# Add jenkins to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Test from jenkins user
sudo su - jenkins -s /bin/bash
docker ps
exit
```

---

## Quick Command Reference

```bash
# Jenkins status
sudo systemctl status jenkins

# Start/Stop/Restart Jenkins
sudo systemctl start jenkins
sudo systemctl stop jenkins
sudo systemctl restart jenkins

# View Jenkins logs
sudo journalctl -u jenkins -f

# Get admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Switch to jenkins user
sudo su - jenkins -s /bin/bash
```

---

## Verify Everything Works

After setup, you should have:
- ✅ Jenkins accessible at http://44.214.128.112:8080
- ✅ Pipeline job created
- ✅ GitHub webhook configured with green ✅
- ✅ Docker Hub credentials added
- ✅ SSH key for EC2 deployment added
- ✅ Git working in Jenkins
- ✅ Auto-trigger on git push

**Test:** Push to GitHub and watch Jenkins automatically build and deploy! 🚀
