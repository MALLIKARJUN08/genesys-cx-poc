# GitHub Actions Setup Guide

## Overview

This guide explains how to set up GitHub Actions for automated Terraform deployments.

## What is GitHub Actions?

GitHub Actions automatically runs your Terraform code whenever you push changes to GitHub. This means:
- No need to manually run `.\deploy.ps1` on your machine
- Logs are captured and stored in GitHub
- Everyone on the team can see deployment status
- Deployment is instant when you push code

---

## Setup Steps

### Step 1: Add GitHub Secrets

GitHub Actions needs your Genesys Cloud OAuth credentials to deploy. These are stored as **Secrets** (encrypted).

#### How to Add Secrets:

1. Go to your GitHub repository: https://github.com/MALLIKARJUN08/genesys-cx-poc

2. Click **Settings** (top menu)

3. Click **Secrets and variables** → **Actions** (left sidebar)

4. Click **New repository secret**

5. Add these 3 secrets:

| Secret Name | Value | Where to get it |
|---|---|---|
| `GENESYSCLOUD_OAUTHCLIENT_ID` | Your OAuth Client ID | Genesys Cloud Admin → OAuth → Copy Client ID |
| `GENESYSCLOUD_OAUTHCLIENT_SECRET` | Your OAuth Client Secret | Genesys Cloud Admin → OAuth → Copy Secret |
| `GENESYSCLOUD_REGION` | Your region (e.g., `us-east-1`) | Genesys Cloud Admin → Your region |

#### Step-by-Step Screenshot Guide:

```
GitHub Repository
  ↓
Settings Tab
  ↓
Secrets and variables (Left Sidebar)
  ↓
Actions
  ↓
New repository secret (Green Button)
  ↓
Name: GENESYSCLOUD_OAUTHCLIENT_ID
Value: your-client-id
  ↓
Add Secret
```

Repeat for all 3 secrets.

---

### Step 2: Verify Workflow File

The workflow file (`.github/workflows/deploy.yml`) is already created. It contains 4 jobs:

1. **terraform-plan** - Checks and plans changes
2. **terraform-apply** - Applies changes to Genesys Cloud
3. **test-deployment** - Verifies resources
4. **documentation** - Updates deployment report

---

## How It Works

### Automatic Trigger

The workflow automatically runs when you:

```powershell
# 1. Make changes to Terraform files
# 2. Commit and push to GitHub
git add .
git commit -m "Update Terraform configuration"
git push origin main
```

### Manual Trigger

You can also manually run the workflow:

1. Go to **Actions** tab on GitHub
2. Click **Genesys CX Terraform Deployment**
3. Click **Run workflow** (green button)
4. Choose branch (main)
5. Click **Run workflow**

---

## Monitor Deployment

### Method 1: GitHub Actions Tab

1. Go to your repository: https://github.com/MALLIKARJUN08/genesys-cx-poc
2. Click **Actions** tab
3. See running/completed workflows
4. Click on a workflow to see detailed logs

### Method 2: View Logs in Real-Time

Click the running workflow → Click on a job → See real-time logs

### Method 3: Download Artifacts

After workflow completes:
1. Click the workflow run
2. Scroll to **Artifacts** section
3. Download:
   - `terraform-plan` - The plan file
   - `deployment-logs` - Detailed logs
   - `terraform-outputs` - Resource outputs

---

## Understanding the Logs

### Log Structure

```
[00:15:22] Checkout Code ✓
[00:15:25] Setup Terraform ✓
[00:15:30] Terraform Init ✓
[00:15:45] Terraform Validate ✓
[00:16:00] Terraform Plan ✓
[00:16:15] Terraform Apply ✓
[00:16:30] Terraform Output ✓
```

### What Each Step Does

| Step | Purpose | What to Look For |
|---|---|---|
| **Init** | Initialize Terraform | Errors about backend or provider |
| **Validate** | Check configuration syntax | Configuration errors |
| **Plan** | Preview changes | What resources will be created |
| **Apply** | Create/update resources | Resource IDs, success messages |
| **Output** | Show resource details | Created resource information |
| **Verify** | Test deployed resources | Confirmation of successful creation |

---

## Troubleshooting

### Issue: Workflow Doesn't Run After Push

**Solutions:**
1. Check that files changed in `modules/`, `main.tf`, `variables.tf`, or `terraform.tfvars`
2. Check the **Actions** tab - is it queued?
3. Check for secrets - are all 3 secrets added?

### Issue: Workflow Fails with Authentication Error

**Check:**
- [ ] Secrets are correctly spelled (case-sensitive)
- [ ] Client ID is correct
- [ ] Client Secret is correct
- [ ] Region is valid (e.g., `us-east-1`)

### Issue: Plan Shows But Apply Doesn't Run

**Reason:** Apply only runs on `main` branch pushes (not PRs)

**Solution:** Make sure you're pushing to `main`, not a feature branch

### Issue: Can't Find Logs

**Where to look:**
1. Go to **Actions** tab
2. Find the workflow run
3. Click on the job (e.g., "Terraform Apply")
4. Scroll down to see all steps and logs

---

## Comparison: Local vs GitHub

| Feature | Local (`.\deploy.ps1`) | GitHub Actions |
|---|---|---|
| **Execution** | You run it manually | Automatic on push |
| **Logs Location** | `deployment.log` on your PC | GitHub Actions tab |
| **Who Can See** | Only you | Everyone with repo access |
| **Schedule** | Run whenever you want | Instant on push |
| **CI/CD Pipeline** | No | Yes (built-in) |
| **Team Collaboration** | Manual sharing | Automatic |

---

## Best Practices

✅ **DO:**
- Always use GitHub Actions for production deployments
- Review the plan before it auto-applies
- Keep secrets secure (don't share them)
- Monitor logs after each deployment

❌ **DON'T:**
- Push OAuth secrets to Git (use GitHub Secrets instead)
- Run both local and GitHub Actions simultaneously
- Deploy to production without reviewing logs
- Share secret values

---

## Quick Reference

### Trigger Deployment
```powershell
git add .
git commit -m "Update configuration"
git push origin main
```

### View Logs
- GitHub: https://github.com/MALLIKARJUN08/genesys-cx-poc/actions
- Click latest workflow run

### Check Artifacts
- After workflow completes
- Download `deployment-logs` artifact

### Manual Trigger
- Go to Actions tab
- Click "Run workflow" button

---

## What Happens After Deployment

### If Successful ✅
```
✓ Resources created in Genesys Cloud
✓ Logs saved as artifacts
✓ Deployment report generated
✓ Team can see outputs
```

### If Failed ❌
```
✗ Workflow stops
✗ Logs show error details
✗ No resources modified
✗ Check logs and fix issues
```

---

## Next Steps

1. **Add the 3 GitHub Secrets** (GENESYSCLOUD_* values)
2. **Push a test commit** to trigger the workflow
3. **Monitor the workflow** in Actions tab
4. **Download logs** and verify deployment
5. **Check Genesys Cloud** for created resources

---

## Questions?

Refer to:
- `.github/workflows/deploy.yml` - Workflow configuration
- `DEPLOY_GUIDE.md` - Local deployment guide
- GitHub Actions docs: https://docs.github.com/en/actions
