# Fix GitHub Actions Docker Hub Error

## Error Message:
```
ERROR: failed to fetch oauth token: unexpected status from GET request to 
https://auth.docker.io/token: 401 Unauthorized: access token has insufficient scopes
```

## Problem:
Your Docker Hub Access Token doesn't have the correct permissions (scopes).

---

## Solution: Create New Docker Hub Token

### Step 1: Go to Docker Hub Security Settings
Open: https://hub.docker.com/settings/security

### Step 2: Delete Old Token (Optional)
- Find your existing "GitHub Actions" token
- Click "Delete" to remove it

### Step 3: Create New Token
1. Click **"New Access Token"**
2. **Description:** `GitHub Actions LawPoint`
3. **Access permissions:** Select **"Read, Write, Delete"** ← IMPORTANT!
4. Click **"Generate"**
5. **COPY THE TOKEN** - You won't see it again!

### Step 4: Update GitHub Secret

1. Go to: https://github.com/Subhaniuduwawala/LawPoint/settings/secrets/actions

2. Find **DOCKERHUB_TOKEN**

3. Click the pencil icon (Edit)

4. **Paste your NEW token**

5. Click **"Update secret"**

### Step 5: Re-run the GitHub Action

1. Go to: https://github.com/Subhaniuduwawala/LawPoint/actions

2. Find the failed workflow run

3. Click **"Re-run all jobs"**

OR

- Go to "Actions" tab
- Click "Build and Push Docker Images"
- Click "Run workflow" → "Run workflow"

---

## Verification

The build should now succeed! You'll see:
- ✅ Login to Docker Hub - Success
- ✅ Build and push backend image - Success
- ✅ Build and push frontend image - Success

---

## Common Issues

### "DOCKERHUB_USERNAME not found"
- Make sure the secret name is exactly: `DOCKERHUB_USERNAME`
- Value should be: `subhaniuduwawala`

### "Token is invalid"
- Make sure you copied the FULL token
- No extra spaces at the beginning or end
- Token should be long (around 50+ characters)

### Still getting 401 error
1. Make sure you selected **"Read, Write, Delete"** permissions
2. Make sure the token is for YOUR Docker Hub account
3. Try generating a new token again

---

## Important Notes

⚠️ **Token Permissions Required:**
- ✅ Read - To pull images
- ✅ Write - To push images
- ✅ Delete - Optional but recommended

⚠️ **Do NOT use:**
- Your Docker Hub password (won't work)
- A token with only "Read" permissions
- An expired or revoked token

---

## Quick Test

After updating the secret, test locally:

```bash
# Test Docker Hub login with the new token
wsl
echo "YOUR_NEW_TOKEN" | docker login -u subhaniuduwawala --password-stdin

# If successful, you'll see: "Login Succeeded"
```

Then re-run the GitHub Action!

---

## Success!

Once fixed, your GitHub Actions will:
1. ✅ Automatically build Docker images on every push
2. ✅ Push to Docker Hub with `latest` tag
3. ✅ Push to Docker Hub with commit SHA tag
4. ✅ Anyone can pull your images instantly

Good luck! 🚀
