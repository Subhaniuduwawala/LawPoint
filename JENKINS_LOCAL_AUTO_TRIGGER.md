# Auto-Trigger Jenkins on Localhost

Since your Jenkins is running locally (not on a public server), GitHub webhooks can't reach it directly. Here are your options:

---

## Option 1: Use SCM Polling (Simpler, No External Tools)

This makes Jenkins check GitHub periodically for changes instead of GitHub pushing to Jenkins.

### Steps:

1. Open your Jenkins job → **Configure**

2. Under **Build Triggers**, check:
   - ✅ **Poll SCM**

3. In the **Schedule** field, enter:
   ```
   H/2 * * * *
   ```
   This checks GitHub every 2 minutes for changes.

   **Other options:**
   - `H/5 * * * *` - Every 5 minutes
   - `* * * * *` - Every minute (not recommended, too frequent)
   - `H * * * *` - Every hour

4. Click **Save**

### How it works:
- Jenkins checks GitHub every 2 minutes
- If there are new commits, it automatically triggers a build
- **Pros:** Simple, no extra tools needed
- **Cons:** Up to 2-minute delay, uses bandwidth

---

## Option 2: Use Ngrok to Expose Localhost (Real-time Webhooks)

Ngrok creates a public URL that forwards to your localhost Jenkins.

### Install Ngrok

**Windows:**
```bash
# Download from https://ngrok.com/download
# Or use Chocolatey:
choco install ngrok
```

**Or use WSL:**
```bash
wsl -d Ubuntu bash -c "curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo 'deb https://ngrok-agent.s3.amazonaws.com buster main' | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok"
```

### Setup Steps:

1. **Sign up at ngrok.com** (free tier works)

2. **Get your auth token** from https://dashboard.ngrok.com/get-started/your-authtoken

3. **Configure ngrok:**
   ```bash
   ngrok config add-authtoken YOUR_AUTH_TOKEN
   ```

4. **Start ngrok tunnel** (keep this running):
   ```bash
   ngrok http 8080
   ```

5. You'll see output like:
   ```
   Forwarding   https://abc123.ngrok.io -> http://localhost:8080
   ```

6. **Copy the ngrok URL** (e.g., `https://abc123.ngrok.io`)

### Configure GitHub Webhook with Ngrok URL:

1. Go to: https://github.com/Subhaniuduwawala/LawPoint/settings/hooks
2. Click **Add webhook** (or edit existing)
3. **Payload URL:** `https://abc123.ngrok.io/github-webhook/`
   (Replace with your actual ngrok URL)
4. **Content type:** `application/json`
5. **Events:** Just the push event
6. Click **Add webhook**

### Configure Jenkins:

1. Open your Jenkins job → **Configure**
2. Under **Build Triggers**, check:
   - ✅ **GitHub hook trigger for GITScm polling**
3. Click **Save**

### How it works:
- GitHub → Ngrok → Your localhost Jenkins
- **Instant** triggering (within seconds)
- **Pros:** Real-time, webhook-based
- **Cons:** Requires ngrok running, free tier has session limits

---

## Option 3: Move Jenkins to EC2 (Best for Production)

If you want a permanent solution without keeping ngrok running, install Jenkins on your EC2 server. See [JENKINS_SETUP.md](JENKINS_SETUP.md) for full instructions.

---

## Recommended Setup for Local Jenkins

**For Development:**
```
Use Option 1 (SCM Polling)
```
- Simplest
- No extra tools
- Good enough for personal projects

**For Testing Webhooks:**
```
Use Option 2 (Ngrok)
```
- Test real webhook behavior
- Faster feedback

**For Production:**
```
Use Option 3 (Jenkins on EC2)
```
- Always accessible
- No local machine dependency
- Professional setup

---

## Update Your Jenkinsfile (Already Done)

Your Jenkinsfile already has the trigger configured:
```groovy
triggers {
    githubPush()
}
```

This works automatically once you enable either:
- GitHub webhooks (with ngrok), OR
- Poll SCM (no ngrok needed)

---

## Test Auto-Trigger

After configuring polling or ngrok:

```bash
# Make a change
echo "test auto-trigger" >> test.txt
git add test.txt
git commit -m "test: auto-trigger test"
git push origin main
```

**With Polling:** Build starts within 2 minutes
**With Ngrok:** Build starts within 10 seconds

Check Jenkins dashboard to see the build start automatically!

---

## Quick Command Reference

### Start Jenkins (if not running)
```bash
# Windows (if installed as service)
net start jenkins

# Or if running in Docker
docker start jenkins

# Or check if running
netstat -ano | findstr :8080
```

### Check Jenkins URL
Open: http://localhost:8080

### Start Ngrok (if using Option 2)
```bash
ngrok http 8080
```

Keep this terminal window open!

### Verify Polling (if using Option 1)
1. Go to Jenkins job
2. Click **Git Polling Log** (on left sidebar)
3. You should see periodic checks

---

## My Recommendation

Since you're running Jenkins locally, I recommend:

**Start with Option 1 (Poll SCM)**
- Set schedule to `H/2 * * * *` (every 2 minutes)
- This will auto-trigger your builds when you push to GitHub
- No extra setup needed
- 2-minute delay is acceptable for most development workflows

Let me know which option you want to use and I can help configure it!
