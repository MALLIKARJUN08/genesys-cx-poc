# Automated Deployment Logging Guide

## Overview
Two automation scripts have been created to execute Terraform operations and automatically log everything to `deployment.log` in real-time.

---

## Scripts Available

### 1. **deploy.ps1** (PowerShell - Windows)
**Location:** `deploy.ps1`

**Usage:**
```powershell
# Execute individual Terraform operations
.\deploy.ps1 -Action init        # Initialize Terraform
.\deploy.ps1 -Action validate    # Validate configuration
.\deploy.ps1 -Action plan        # Plan infrastructure changes
.\deploy.ps1 -Action apply       # Apply infrastructure changes
.\deploy.ps1 -Action destroy     # Destroy infrastructure
.\deploy.ps1 -Action output      # Show Terraform outputs
.\deploy.ps1 -Action all         # Run all steps (except apply)

# Execute all steps with auto-approval
.\deploy.ps1 -Action all -AutoApprove

# Auto-approve apply only
.\deploy.ps1 -Action apply -AutoApprove
```

**Features:**
- ✅ Real-time logging to deployment.log
- ✅ Timestamped entries
- ✅ Color-coded console output
- ✅ Error handling with exit codes
- ✅ Progress tracking
- ✅ Auto-approve flag for CI/CD

---

### 2. **deploy.sh** (Bash - Linux/Mac)
**Location:** `deploy.sh`

**First, make it executable:**
```bash
chmod +x deploy.sh
```

**Usage:**
```bash
# Execute individual Terraform operations
./deploy.sh init                    # Initialize Terraform
./deploy.sh validate                # Validate configuration
./deploy.sh plan                    # Plan infrastructure changes
./deploy.sh apply                   # Apply infrastructure changes
./deploy.sh destroy                 # Destroy infrastructure
./deploy.sh output                  # Show Terraform outputs
./deploy.sh all                     # Run all steps (except apply)

# Execute all steps with auto-approval
./deploy.sh all --auto-approve

# Auto-approve apply only
./deploy.sh apply --auto-approve
```

**Features:**
- ✅ Real-time logging to deployment.log
- ✅ Timestamped entries
- ✅ Color-coded output (RED, GREEN, YELLOW, BLUE)
- ✅ Error handling
- ✅ Progress tracking
- ✅ Auto-approve flag for CI/CD

---

## What Gets Logged

### Real-Time Logging to deployment.log

Each operation logs:
- **Timestamp** - Exact date/time of operation
- **Log Level** - INFO, SUCCESS, ERROR, WARNING, OUTPUT
- **Operation Details** - What is being executed
- **Command Output** - Full Terraform command output
- **Status** - Success or failure
- **Exit Codes** - Whether command succeeded

**Example log entry:**
```
[2026-03-25 14:30:15] INFO: Starting Terraform deployment with action: plan
[2026-03-25 14:30:16] INFO: Working directory: /path/to/project
[2026-03-25 14:30:17] INFO: ========== TERRAFORM PLAN ==========
[2026-03-25 14:30:18] INFO: Planning infrastructure changes
[2026-03-25 14:30:20] OUTPUT: Terraform will perform the following actions:
[2026-03-25 14:30:21] OUTPUT:   # module.users.genesyscloud_user.users["arjunv"] will be created
[2026-03-25 14:30:22] SUCCESS: ✓ Terraform plan completed successfully
```

---

## Typical Workflow

### Step 1: Initialize Terraform
```powershell
# PowerShell
.\deploy.ps1 -Action init
```
```bash
# Bash
./deploy.sh init
```
✅ Check deployment.log for initialization logs

---

### Step 2: Validate Configuration
```powershell
.\deploy.ps1 -Action validate
```
```bash
./deploy.sh validate
```
✅ Check deployment.log for validation results

---

### Step 3: Plan Changes
```powershell
.\deploy.ps1 -Action plan
```
```bash
./deploy.sh plan
```
✅ Check deployment.log to see what will be created/changed

---

### Step 4: Apply Changes
```powershell
# Review plan first, then apply
.\deploy.ps1 -Action apply
# Or auto-approve:
.\deploy.ps1 -Action apply -AutoApprove
```
```bash
# Review plan first, then apply
./deploy.sh apply
# Or auto-approve:
./deploy.sh apply --auto-approve
```
✅ Check deployment.log for resource creation logs with IDs

---

### Step 5: View Outputs
```powershell
.\deploy.ps1 -Action output
```
```bash
./deploy.sh output
```
✅ Check deployment.log for resource outputs (IDs, names)

---

## Monitoring Logs in Real-Time

### Option 1: View Full Log File
```powershell
# PowerShell
Get-Content deployment.log
Get-Content deployment.log -Tail 50  # Last 50 lines
```

```bash
# Bash
cat deployment.log
tail -50 deployment.log  # Last 50 lines
tail -f deployment.log   # Follow in real-time
```

### Option 2: Search Logs
```powershell
# PowerShell - Find all errors
Select-String "ERROR" deployment.log

# Find all successful operations
Select-String "SUCCESS" deployment.log
```

```bash
# Bash - Find all errors
grep "ERROR" deployment.log

# Find all successful operations
grep "SUCCESS" deployment.log
```

### Option 3: View in HTML Report
```
Open report.html in browser → Check "Deployment & Execution Logs" section
```

---

## Auto-Approval for CI/CD

For automated deployments in CI/CD pipelines:

```powershell
# PowerShell - Full automation
.\deploy.ps1 -Action all -AutoApprove
```

```bash
# Bash - Full automation
./deploy.sh all --auto-approve
```

This will:
1. Initialize Terraform
2. Validate configuration
3. Plan changes
4. Apply changes automatically
5. All logged to deployment.log

---

## Environment Variables

Before running, ensure these environment variables are set:

```powershell
# PowerShell
$env:GENESYSCLOUD_OAUTHCLIENT_ID="your-client-id"
$env:GENESYSCLOUD_OAUTHCLIENT_SECRET="your-client-secret"
$env:GENESYSCLOUD_REGION="your-region"
```

```bash
# Bash
export GENESYSCLOUD_OAUTHCLIENT_ID="your-client-id"
export GENESYSCLOUD_OAUTHCLIENT_SECRET="your-client-secret"
export GENESYSCLOUD_REGION="your-region"
```

---

## Log File Location

**deployment.log** is located in the project root directory:
```
c:\Users\mavedula\OneDrive - Capgemini\Desktop\poc\genesys-cx-poc\deployment.log
```

---

## Troubleshooting

### Logs not updating?
- Verify deployment.log exists in project root
- Check file permissions (must be writable)
- Ensure Terraform is in PATH

### Script won't execute (PowerShell)?
```powershell
# Check execution policy
Get-ExecutionPolicy

# If restricted, allow scripts:
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Script won't execute (Bash)?
```bash
# Make executable
chmod +x deploy.sh

# Run with bash explicitly
bash deploy.sh init
```

---

## Example Complete Session

```powershell
# PowerShell Example
PS> .\deploy.ps1 -Action init
[2026-03-25 14:30:00] INFO: Initializing Terraform...
[2026-03-25 14:30:05] SUCCESS: ✓ Init completed

PS> .\deploy.ps1 -Action validate
[2026-03-25 14:30:10] INFO: Validating configuration...
[2026-03-25 14:30:15] SUCCESS: ✓ Validation passed

PS> .\deploy.ps1 -Action plan
[2026-03-25 14:30:20] INFO: Planning changes...
[2026-03-25 14:30:35] SUCCESS: ✓ Plan completed
[2026-03-25 14:30:35] INFO: Plan: 3 to add, 0 to change, 0 to destroy

PS> .\deploy.ps1 -Action apply -AutoApprove
[2026-03-25 14:30:40] INFO: Applying changes...
[2026-03-25 14:31:00] SUCCESS: ✓ Apply completed
[2026-03-25 14:31:05] SUCCESS: ✓ 3 resources created

# All logged to deployment.log with full details!
```

---

## Summary

✅ **Two scripts provided:**
- `deploy.ps1` for Windows/PowerShell
- `deploy.sh` for Linux/Mac/Bash

✅ **Real-time logging** to `deployment.log`

✅ **Automatic timestamps** on every operation

✅ **Color-coded output** for easy readability

✅ **Error handling** with proper exit codes

✅ **CI/CD friendly** with auto-approval options

✅ **Full audit trail** of all infrastructure changes

---

**Start logging now:**
```powershell
.\deploy.ps1 -Action init
```

Check the logs:
```powershell
Get-Content deployment.log
```

View in browser:
```
Open report.html
```
