# Architect Flows Deployment Guide

## Overview

This guide explains how to deploy Architect flows to Genesys Cloud using Terraform.

---

## File Structure

```
genesys-cx-poc/
├── flows/                           ← Store your YAML flow files here
│   └── sample_flow.yaml             ← Placeholder - replace with your flow
├── modules/flows/                   ← Flows module
│   ├── main.tf                      ← Flow resource definition
│   ├── variables.tf                 ← Variable declarations
│   ├── outputs.tf                   ← Output flow details
│   └── versions.tf                  ← Provider versions
├── environments/                    ← Environment-specific configurations
│   ├── poc.tfvars                   ← POC: All resources (skills, users, queues, flows)
│   └── prod_flow_only.tfvars        ← PROD: All resources (rename to prod.tfvars)
└── main.tf                          ← Root orchestration
```

**NOTE:** Rename `prod_flow_only.tfvars` → `prod.tfvars` for consistency

---

## Step-by-Step: Adding Your First Flow

### Step 1: Export Flow from Architect

1. Open **Genesys Architect**
2. Open the flow you want to deploy
3. Click **Publish** → **Export**
4. Select **YAML** format
5. Copy the entire YAML content

### Step 2: Save YAML File

1. Create/Edit file: `./flows/your_flow_name.yaml`
2. Paste the exported YAML content
3. Save the file

Example:
```bash
# File: ./flows/inbound_call_flow.yaml
# Content: (paste your exported YAML here)
```

### Step 3: Update Configuration File

Edit the appropriate tfvars file for your environment:

**For POC testing first:**
Edit `environments/poc_flow_only.tfvars`:

```hcl
flows = {
  "my_inbound_flow" = {
    name        = "My Inbound Call Flow"
    description = "Inbound call flow exported from Architect"
    type        = "inboundcall"
    filepath    = "${path.module}/flows/inbound_call_flow.yaml"
    locked      = false  # Allow editing for testing
  }
}
```

**For PROD deployment:**
Edit `environments/prod_flow_only.tfvars`:

```hcl
flows = {
  "my_inbound_flow" = {
    name        = "My Inbound Call Flow"
    description = "Production inbound call flow"
    type        = "inboundcall"
    filepath    = "${path.module}/flows/inbound_call_flow.yaml"
    locked      = true  # Lock for production safety
  }
}
```

### Step 4: Deploy

**Deploy to POC:**
```bash
terraform workspace select poc
terraform apply -var-file="environments/poc.tfvars"
```

**Deploy to PROD:**
```bash
terraform workspace select prod
terraform apply -var-file="environments/prod_flow_only.tfvars"  # Or rename to prod.tfvars
```

**Key Point:** No matter how many times you run the same tfvars file, Terraform will:
- ✅ Keep existing resources intact
- ✅ Only create/update new flows
- ✅ Never duplicate anything (state prevents this)

---

## Deployment Scenarios

### Scenario 1: Deploy Everything to POC (Initial Setup)

**When:** First time setup or updating POC infrastructure + flows
**Tfvars File:** `environments/poc.tfvars`
**Command:**
```bash
terraform workspace select poc
terraform apply -var-file="environments/poc.tfvars"
```

**What Happens:**
- ✅ Skills created/updated
- ✅ Users created/updated
- ✅ Queues created/updated
- ✅ Flows created/updated
- Terraform state: Updated with all resources

---

### Scenario 2: Update Flows in POC (After Initial Setup)

**When:** Testing flow changes only (infrastructure already created)
**Tfvars File:** `environments/poc.tfvars`
**Command:**
```bash
terraform apply -var-file="environments/poc.tfvars"
```

**What Happens:**
- ✅ Only NEW flows deployed (existing infrastructure untouched)
- ❌ Skills, users, queues: NO CHANGE (already in state)
- Terraform state: Only new flows added

---

### Scenario 3: Deploy Everything to PROD (Production Deployment)

**When:** Deploying infrastructure + flows to production
**Tfvars File:** `environments/prod_flow_only.tfvars` (or rename to `prod.tfvars`)
**Command:**
```bash
terraform workspace select prod
terraform apply -var-file="environments/prod_flow_only.tfvars"
```

**What Happens:**
- ✅ All infrastructure created (if not exists)
- ✅ All flows created (if not exists)
- ✅ ONLY updates changed resources (Terraform state prevents duplicates)

---

## Configuration Details

### Flow Variable Options

| Option | Type | Required | Description |
|--------|------|----------|-------------|
| `name` | string | Yes | Display name in Genesys Cloud |
| `description` | string | No | Flow purpose/description |
| `type` | string | Yes | Flow type: "inboundcall", "inboundemail", etc. |
| `filepath` | string | Yes | Path to YAML file, e.g., "${path.module}/flows/my_flow.yaml" |
| `locked` | bool | No | Lock flow from editing in UI (default: false) |

### Feature Flags

Use these to control which resources get created:

```hcl
create_divisions = true   # Create divisions
create_skills    = true   # Create skills
create_users     = true   # Create users
create_queues    = true   # Create queues
create_roles     = true   # Create roles
create_flows     = true   # Create flows
```

**Example: Deploy only flows**
```hcl
create_divisions = false
create_skills    = false
create_users     = false
create_queues    = false
create_roles     = false
create_flows     = true
```

---

## Common Flow Types

```hcl
type = "inboundcall"          # Inbound voice calls
type = "inboundemail"         # Inbound email
type = "inboundshortmessage"  # Inbound SMS/chat
type = "outboundcall"         # Outbound calls
type = "inqueuecall"          # In-queue call flows
```

---

## Troubleshooting

### Error: "Flow definition is invalid"

**Cause:** YAML file format issue
**Solution:**
- Ensure YAML is properly exported from Architect
- Don't manually edit the YAML (copy-paste from Architect export)
- Check for proper indentation

### Error: "Queue/Skill not found"

**Cause:** Referenced queue/skill doesn't exist
**Solution:**
- Ensure queues/skills are created first
- Or use `poc.tfvars` which creates everything
- Check queue/skill names match exactly

### Error: "File not found"

**Cause:** Incorrect filepath
**Solution:**
- Verify file exists in `./flows/` directory
- Use correct filename (case-sensitive on some systems)
- Use `${path.module}/flows/filename.yaml` format

---

## GitHub Actions Integration

### Deploying via GitHub Actions

**Push to main branch:**
```bash
git push origin main
# GitHub Actions auto-deploys to POC
```

**Manual deployment (workflow dispatcher):**
1. Go to GitHub → Actions tab
2. Click "Terraform Deploy" workflow
3. Click "Run workflow"
4. Select deployment scenario:
   - `poc_flow_only` (test flow in POC)
   - `prod_flow_only` (deploy to PROD)
5. Click "Run"

---

## Best Practices

1. **Test in POC First:** Always test flow deployment in POC before PROD
2. **Lock Flows in PROD:** Use `locked = true` in production
3. **Version Control:** Keep all YAML files in Git
4. **Clear Names:** Use descriptive flow names (e.g., "Inbound Sales Flow")
5. **Document Changes:** Add comments in tfvars files explaining flow purpose

---

## Example: Complete Flow Deployment

```hcl
# environments/poc_flow_only.tfvars

create_divisions = false
create_skills    = false
create_users     = false
create_queues    = false
create_roles     = false
create_flows     = true

divisions = {}
skills    = {}
users     = {}
queues    = {}
roles     = {}

flows = {
  "sales_inbound_flow" = {
    name        = "Sales Inbound Call Flow"
    description = "Routes incoming sales calls to sales queue"
    type        = "inboundcall"
    filepath    = "${path.module}/flows/sales_inbound_flow.yaml"
    locked      = false
  }
  
  "billing_transfer_flow" = {
    name        = "Billing Call Transfer"
    description = "Transfers calls to billing queue"
    type        = "inboundcall"
    filepath    = "${path.module}/flows/billing_transfer_flow.yaml"
    locked      = false
  }
}
```

---

## Next Steps

1. **Export your flow** from Architect
2. **Save YAML file** to `./flows/` directory
3. **Update tfvars** with flow configuration
4. **Test in POC** first: `terraform apply -var-file="environments/poc_flow_only.tfvars"`
5. **Deploy to PROD:** `terraform apply -var-file="environments/prod_flow_only.tfvars"`

Good luck! 🚀
