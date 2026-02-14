# GitHub Webhook Setup for Jenkins Auto-Trigger

## Step 1: Configure Jenkins

### Install GitHub Plugin (if not already installed)
1. Go to Jenkins Dashboard → **Manage Jenkins** → **Manage Plugins**
2. Go to **Available** tab
3. Search for "**GitHub Integration Plugin**"
4. Install and restart Jenkins

### Get Jenkins Webhook URL
Your Jenkins webhook URL format:
```
http://<JENKINS_URL>/github-webhook/
```

**Example:**
```
http://44.214.128.112:8080/github-webhook/
```

---

## Step 2: Configure GitHub Repository Webhook

1. Go to your GitHub repository: https://github.com/Subhaniuduwawala/LawPoint

2. Click **Settings** → **Webhooks** → **Add webhook**

3. Configure the webhook:
   - **Payload URL:** `http://44.214.128.112:8080/github-webhook/`
   - **Content type:** `application/json`
   - **Secret:** (leave empty or add a secret token)
   - **Which events would you like to trigger this webhook?**
     - Select: "**Just the push event**"
   - **Active:** ✅ Checked

4. Click **Add webhook**

5. GitHub will send a test ping. Check the webhook shows a ✅ green checkmark.

---

## Step 3: Configure Jenkins Job

### For Pipeline Job:
1. Go to your Jenkins job → **Configure**

2. Under **Build Triggers**, enable:
   - ✅ **GitHub hook trigger for GITScm polling**

3. Under **Pipeline** section:
   - **Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** `https://github.com/Subhaniuduwawala/LawPoint.git`
   - **Branch Specifier:** `*/main`
   - **Script Path:** `Jenkinsfile`

4. Click **Save**

---

## Step 4: Test the Webhook

1. Make any change to your repository:
   ```bash
   echo "test" >> test.txt
   git add test.txt
   git commit -m "test webhook trigger"
   git push origin main
   ```

2. Jenkins should automatically start building within seconds

3. Check Jenkins Dashboard to see the build running

---

## Troubleshooting

### Webhook not triggering Jenkins

**1. Check Jenkins is accessible from internet:**
```bash
curl -I http://44.214.128.112:8080/github-webhook/
```
Should return HTTP 200 or 403 (both are OK)

**2. Check GitHub webhook deliveries:**
- Go to GitHub → Settings → Webhooks
- Click on the webhook
- Check "Recent Deliveries" tab
- Look for green ✅ or red ❌ status

**3. Check Jenkins security:**
- Go to Jenkins → Manage Jenkins → Configure Global Security
- Under "**CSRF Protection**", ensure "Enable proxy compatibility" is checked
- Or disable CSRF for webhook URL (not recommended)

**4. Use ngrok if Jenkins is behind firewall:**
```bash
ngrok http 8080
```
Then use the ngrok URL as webhook URL

**5. Check Jenkins logs:**
```bash
# On Jenkins server
sudo tail -f /var/log/jenkins/jenkins.log
```

---

## Alternative: Poll SCM (Less Efficient)

If webhook doesn't work, use polling instead:

1. In Jenkins job → **Configure**
2. Under **Build Triggers**, enable:
   - ✅ **Poll SCM**
   - **Schedule:** `H/5 * * * *` (checks every 5 minutes)

---

## Verify Configuration

After setup, check:
- [x] GitHub webhook shows green checkmark
- [x] Jenkins job has "GitHub hook trigger" enabled
- [x] Manual git push triggers automatic build
- [x] Jenkins build log shows "Started by GitHub push"

---

## Status Check

Run this to verify Jenkins webhook endpoint:
```bash
curl -X POST http://44.214.128.112:8080/github-webhook/
```

Expected: Should return success or trigger a scan.
