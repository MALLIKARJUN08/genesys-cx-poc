# Genesys CX as Code POC - Complete Project Documentation

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Project Structure](#project-structure)
4. [Core Components](#core-components)
5. [Implementation Guide](#implementation-guide)
6. [File-by-File Breakdown](#file-by-file-breakdown)

---

## Project Overview

**Project Name:** `genesys-cx-poc`

**Purpose:** Infrastructure as Code (IaC) solution to automate the provisioning and management of Genesys Cloud resources (Queues, Users, and Roles) using Terraform.

**Owner:** MALLIKARJUN08

**Repository:** GitHub - `genesys-cx-poc`

**Current Branch:** `main`

**Key Benefits:**
- Automated infrastructure deployment
- Version-controlled configuration
- Consistent resource management
- Scalable architecture for multiple environments
- Reduced manual configuration errors

---

## Architecture

### High-Level Design

```
┌─────────────────────────────────────────────────────────────┐
│                    terraform.tfvars                         │
│          (User Configuration - Values Only)                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────────────────────┐
│                  Root Module (main.tf)                       │
│            (Orchestration Layer)                            │
│  - Calls 3 child modules                                   │
│  - Passes data to modules                                  │
│  - Manages state migration                                 │
└──────────────────────┬──────────────────────────────────────┘
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
┌────────────┐  ┌────────────┐  ┌────────────┐
│  Queues    │  │   Users    │  │   Roles    │
│  Module    │  │   Module   │  │   Module   │
└────────────┘  └────────────┘  └────────────┘
        │              │              │
        ▼              ▼              ▼
┌────────────┐  ┌────────────┐  ┌────────────┐
│   Create   │  │   Create   │  │   Create   │
│   Queues   │  │   Users    │  │   Roles    │
│   in GX    │  │   in GX    │  │   in GX    │
└────────────┘  └────────────┘  └────────────┘
```

### Why This Architecture?

| Layer | Purpose | Benefit |
|-------|---------|---------|
| **terraform.tfvars** | Values/Configuration | Users only edit this file |
| **Root variables.tf** | Variable definitions | Single entry point for all inputs |
| **Root main.tf** | Module orchestration | Centralized resource management |
| **Module variables.tf** | Module input contract | Modules are reusable & independent |
| **Module main.tf** | Resource creation | Each module handles one domain |

---

## Project Structure

```
genesys-cx-poc/
├── main.tf                          # Root orchestration
├── variables.tf                     # Root variable definitions
├── outputs.tf                       # Root outputs
├── versions.tf                      # Provider & Terraform version config
├── terraform.tfvars                 # User configuration values
├── README.md                        # Quick start guide
├── project.md                       # This file (detailed documentation)
│
└── modules/
    ├── queues/
    │   ├── main.tf                  # Queue resource creation
    │   ├── variables.tf             # Queue variable definitions
    │   ├── outputs.tf               # Queue outputs
    │   └── versions.tf              # Queue provider config
    │
    ├── users/
    │   ├── main.tf                  # User resource creation
    │   ├── variables.tf             # User variable definitions
    │   ├── outputs.tf               # User outputs
    │   └── versions.tf              # User provider config
    │
    └── roles/
        ├── main.tf                  # Role resource creation
        ├── variables.tf             # Role variable definitions
        ├── outputs.tf               # Role outputs
        └── versions.tf              # Role provider config
```

---

## Core Components

### 1. **Queues Module**
**Purpose:** Create and manage Genesys Cloud Routing Queues

**Key Features:**
- Automated flow lookup by name or ID
- Automated prompt lookup by name or ID
- Bullseye routing with expanding rings
- Conditional group activation (CGA)
- Media settings and SLA configuration
- Service level targets

**Resources Created:** `genesyscloud_routing_queue`

---

### 2. **Users Module**
**Purpose:** Create and manage Genesys Cloud User Accounts

**Key Features:**
- Simple user creation with name, email, state
- Built-in email validation
- State management (active/inactive)
- Supports multiple users via `for_each`

**Resources Created:** `genesyscloud_user`

---

### 3. **Roles Module**
**Purpose:** Create and manage Genesys Cloud Authorization Roles

**Key Features:**
- Custom role creation
- Permission-based access control
- Flexible permission assignment
- Supports multiple roles via `for_each`

**Resources Created:** `genesyscloud_auth_role`

---

## Implementation Guide

### Step 1: Project Setup

#### 1.1 Prerequisites
- Terraform >= v1.0.0
- Genesys Cloud OAuth credentials
- GitHub account (if using automation)
- HCP Terraform account (for state management)

#### 1.2 Terraform Initialization
```bash
terraform init
```
This command:
- Downloads the Genesys Cloud provider
- Initializes the Terraform working directory
- Connects to HCP Terraform for state management

#### 1.3 Provider Configuration
The provider is configured in `versions.tf`:
```terraform
provider "genesyscloud" {
  # Credentials injected via environment variables:
  # GENESYSCLOUD_OAUTHCLIENT_ID
  # GENESYSCLOUD_OAUTHCLIENT_SECRET
  # GENESYSCLOUD_REGION
}
```

**Security:** Credentials are never hardcoded, always use environment variables or Terraform Cloud variables.

---

### Step 2: Configuration

#### 2.1 Edit terraform.tfvars
This is the **ONLY file** operators should edit.

```hcl
# Example configuration
queues = {
  "example_queue" = {
    name        = "Sample_Queue"
    description = "A sample queue"
    # ... additional fields
  }
}

users = {
  "sample_admin" = {
    name  = "Sample Admin"
    email = "admin@example.com"
    state = "active"
  }
  "arjunv" = {
    name  = "Arjun V"
    email = "arjunv@example.com"
    state = "active"
  }
}

roles = {
  "custom_role" = {
    name        = "Custom Role"
    description = "A custom role"
    permissions = ["routing:queue:view", "routing:queue:edit"]
  }
}
```

#### 2.2 Validate Configuration
```bash
terraform validate
```
Checks syntax and configuration validity.

#### 2.3 Plan Changes
```bash
terraform plan
```
Shows what resources will be created/modified/destroyed before applying.

---

### Step 3: Deployment

#### 3.1 Apply Configuration
```bash
terraform apply
```
Creates actual resources in Genesys Cloud.

#### 3.2 Review Outputs
```bash
terraform output
```
Displays created resource IDs and names for verification.

---

### Step 4: Maintenance

#### 4.1 Update Configuration
Edit `terraform.tfvars` and run `terraform apply` again.

#### 4.2 Destroy Resources (if needed)
```bash
terraform destroy
```
Removes all resources created by Terraform.

---

## File-by-File Breakdown

### Root Level Files

#### 1. `versions.tf` - Provider & Version Configuration

**Purpose:** Specify Terraform and provider version requirements

**Contents:**
```terraform
terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    genesyscloud = {
      source  = "mypurecloud/genesyscloud"
      version = "~> 1.40"
    }
  }
  
  cloud {
    organization = "cg_genesys"
    workspaces {
      tags = ["genesys-cx"]
    }
  }
}

provider "genesyscloud" {
  # Credentials via environment variables (not hardcoded)
}
```

**Key Points:**
- `required_version`: Ensures minimum Terraform version
- `required_providers`: Specifies Genesys Cloud provider source & version
- `cloud`: Configures HCP Terraform backend for state storage
- **Security:** Never hardcode OAuth credentials

---

#### 2. `variables.tf` - Root Variable Definitions

**Purpose:** Define input variables accepted by the root module

**Structure:**

```terraform
variable "queues" {
  description = "A complex object containing all configuration options for Genesys Cloud Queues"
  type = map(object({
    name                    = string
    description             = optional(string)
    division_id             = optional(string)
    acw_wrapup_prompt       = optional(string)
    acw_timeout_ms          = optional(number)
    # ... many more fields
  }))
  default = {}
}

variable "users" {
  description = "A map of users to create"
  type = map(object({
    name  = string
    email = string
    state = string
  }))
  default = {}
  
  validation {
    condition     = alltrue([for u in var.users : contains(["active", "inactive"], u.state)])
    error_message = "User state must be either 'active' or 'inactive'."
  }
  
  validation {
    condition     = alltrue([for u in var.users : can(regex("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$", u.email))])
    error_message = "All user emails must be in a valid email format."
  }
}

variable "roles" {
  description = "A map of roles to create"
  type = map(object({
    name        = string
    description = string
    permissions = list(string)
  }))
  default = {}
}
```

**Why Root Variables?**
- Acts as the **API contract** for the entire infrastructure
- Provides a **single entry point** for all inputs
- Enables **validation** and **documentation**
- Makes modules **reusable** across projects

---

#### 3. `main.tf` - Module Orchestration

**Purpose:** Call child modules and pass variables

**Contents:**

```terraform
module "queues" {
  source = "./modules/queues"
  queues = var.queues
}

module "users" {
  source = "./modules/users"
  users  = var.users
}

module "roles" {
  source = "./modules/roles"
  roles  = var.roles
}

# State migration blocks (prevent resource recreation during refactoring)
moved {
  from = module.queues.genesyscloud_routing_queue.poc_queue
  to   = module.queues.genesyscloud_routing_queue.queues["poc_queue"]
}
```

**Key Concepts:**

| Concept | Explanation |
|---------|-------------|
| **source** | Path to the module code |
| **var.queues** | Pass root variables to modules |
| **moved** | Rename state addresses without destroying resources |

---

#### 4. `outputs.tf` - Output Values

**Purpose:** Expose created resource information to users

**Contents:**

```terraform
output "queues" {
  description = "Consolidated details (IDs and Names) of all created Routing Queues"
  value       = module.queues.queue_details
}

output "users" {
  description = "Consolidated details (IDs and Names) of all created Users"
  value       = module.users.user_details
}

output "roles" {
  description = "Consolidated details (IDs and Names) of all created Authorization Roles"
  value       = module.roles.role_details
}
```

**Why Outputs?**
- Display important resource information after deployment
- Allow other systems to reference created resources
- Provide feedback to users about what was created

---

#### 5. `terraform.tfvars` - Configuration Values

**Purpose:** Provide actual values for variables defined in `variables.tf`

**Current Configuration:**

```hcl
queues = {
  "example_queue" = {
    name                    = "Sample_Advanced_Queue"
    description             = "A queue demonstrating automated Name-to-ID lookups"
    acw_wrapup_prompt       = "MANDATORY_TIMEOUT"
    acw_timeout_ms          = 300000
    skill_evaluation_method = "BEST"
    queue_flow_name         = "Default In-Queue Flow"
    queue_flow_type         = "inqueuecall"
    whisper_prompt_name     = "abc"
    # ... more settings
  }
}

users = {
  "sample_admin" = {
    name  = "Sample Admin"
    email = "admin@example.com"
    state = "active"
  }
  "arjunv" = {
    name  = "Arjun V"
    email = "arjunv@example.com"
    state = "active"
  }
}
```

**Who Edits This?**
- Contact Center Administrators
- Infrastructure Teams
- Not developers (they maintain modules)

---

### Module Files

#### 6. `modules/users/variables.tf`

**Purpose:** Define what the users module expects to receive

```terraform
variable "users" {
  description = "A map of users to create"
  type = map(object({
    name  = string
    email = string
    state = string
  }))
  default = {}
  
  validation {
    condition     = alltrue([for u in var.users : contains(["active", "inactive"], u.state)])
    error_message = "User state must be either 'active' or 'inactive'."
  }
  
  validation {
    condition     = alltrue([for u in var.users : can(regex("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$", u.email))])
    error_message = "All user emails must be in a valid email format."
  }
}
```

**Validation Rules:**
1. **State Validation:** Ensures state is either "active" or "inactive"
2. **Email Validation:** Ensures email follows standard format (name@domain.com)

---

#### 7. `modules/users/main.tf`

**Purpose:** Create user resources

```terraform
resource "genesyscloud_user" "users" {
  for_each = var.users
  
  name  = each.value.name
  email = each.value.email
  state = each.value.state
}
```

**How `for_each` Works:**
- Iterates through the `users` map
- `each.key` = Map key (e.g., "sample_admin", "arjunv")
- `each.value` = Map value (object with name, email, state)
- Creates one resource per map entry

**Example Execution:**
```
Input: users = {
  "admin" = { name = "Admin", email = "admin@test.com", state = "active" },
  "arjunv" = { name = "Arjun V", email = "arjunv@test.com", state = "active" }
}

Creates:
- genesyscloud_user.users["admin"]
- genesyscloud_user.users["arjunv"]
```

---

#### 8. `modules/users/outputs.tf`

**Purpose:** Expose user details to root module

```terraform
output "user_details" {
  description = "Details of created users"
  value = {
    for k, v in genesyscloud_user.users : k => {
      name = v.name
      id   = v.id
    }
  }
}
```

**Output Structure:**
```
{
  "admin" = {
    name = "Admin"
    id   = "user-id-123"
  }
  "arjunv" = {
    name = "Arjun V"
    id   = "user-id-456"
  }
}
```

---

#### 9. `modules/queues/main.tf`

**Purpose:** Create and configure routing queues

**Key Features:**

1. **Automated Name-to-ID Lookup:**
```terraform
queue_flow_id = each.value.queue_flow_id != null ? 
                each.value.queue_flow_id : 
                (each.value.queue_flow_name != null ? 
                 data.genesyscloud_flow.flows[each.value.queue_flow_name].id : null)
```
- If `queue_flow_id` is provided, use it
- Else if `queue_flow_name` is provided, look it up
- Else set to null

2. **Dynamic Blocks:**
```terraform
dynamic "media_settings_call" {
  for_each = each.value.media_settings_call != null ? [each.value.media_settings_call] : []
  content {
    alerting_timeout_sec      = media_settings_call.value.alerting_timeout_sec
    service_level_percentage  = media_settings_call.value.service_level_percentage
    service_level_duration_ms = media_settings_call.value.service_level_duration_ms
  }
}
```
- Only creates block if data is provided
- Avoids setting empty values

3. **Bullseye Routing:**
```terraform
dynamic "bullseye_rings" {
  for_each = each.value.bullseye_rings != null ? each.value.bullseye_rings : []
  content {
    expansion_timeout_seconds = bullseye_rings.value.expansion_timeout_seconds
    # Nested dynamic block for groups
    dynamic "member_groups" { ... }
  }
}
```
- Supports expanding rings of agent groups
- Each ring has different expansion timeout
- Supports automated group name lookups

---

#### 10. `modules/roles/main.tf`

**Purpose:** Create custom authorization roles

```terraform
resource "genesyscloud_auth_role" "custom_roles" {
  for_each    = var.roles
  
  name        = each.value.name
  description = each.value.description
  permissions = each.value.permissions
}
```

**Permission Examples:**
```hcl
permissions = [
  "routing:queue:view",
  "routing:queue:edit",
  "routing:queue:delete",
  "users:user:view",
  "users:user:edit"
]
```

---

## Advanced Concepts

### 1. Data Sources (Name-to-ID Lookup)

The queues module uses data sources to find resources by name:

```terraform
data "genesyscloud_flow" "flows" {
  for_each = toset(compact([
    for q in var.queues : q.queue_flow_name if q.queue_flow_name != null
  ]))
  name = each.value
}
```

**Why?**
- Users can provide human-readable names
- Terraform looks up the IDs automatically
- Makes configuration more user-friendly

### 2. Conditional Logic

```terraform
division_id = each.value.division_id != null ? 
              each.value.division_id : 
              data.genesyscloud_auth_division_home.home.id
```

**Logic:**
- If division_id provided, use it
- Otherwise, use home division

### 3. List Consolidation

```terraform
groups = distinct(compact(concat(
  each.value.groups != null ? each.value.groups : [],
  each.value.group_names != null ? [for g in each.value.group_names : data.genesyscloud_group.groups[g].id] : []
)))
```

**What This Does:**
1. `concat()` - Combine two lists
2. `compact()` - Remove null values
3. `distinct()` - Remove duplicates

---

## Common Tasks

### Add a New User

**Step 1:** Edit `terraform.tfvars`
```hcl
users = {
  "sample_admin" = {
    name  = "Sample Admin"
    email = "admin@example.com"
    state = "active"
  }
  "new_user" = {           # Add this
    name  = "New User"
    email = "newuser@example.com"
    state = "active"
  }
}
```

**Step 2:** Apply changes
```bash
terraform apply
```

**Step 3:** Verify
```bash
terraform output users
```

---

### Create a Custom Role

**Edit `terraform.tfvars`:**
```hcl
roles = {
  "supervisor_role" = {
    name        = "Supervisor"
    description = "Supervisor role with queue management"
    permissions = [
      "routing:queue:view",
      "routing:queue:edit",
      "users:user:view",
      "analytics:conversationDetail:view"
    ]
  }
}
```

---

### Configure Advanced Queue Settings

**Edit `terraform.tfvars`:**
```hcl
queues = {
  "advanced_queue" = {
    name                     = "Advanced Queue"
    description              = "Queue with advanced routing"
    acw_wrapup_prompt        = "MANDATORY_TIMEOUT"
    acw_timeout_ms           = 300000
    enable_transcription     = true
    enable_audio_monitoring  = true
    skill_evaluation_method  = "BEST"
    
    media_settings_call = {
      alerting_timeout_sec      = 30
      service_level_percentage  = 0.8
      service_level_duration_ms = 20000
    }
    
    bullseye_rings = [
      {
        expansion_timeout_seconds = 15
        member_group_names        = ["Premium Agents"]
      },
      {
        expansion_timeout_seconds = 30
        member_group_names        = ["Regular Agents"]
      }
    ]
  }
}
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| **Provider auth fails** | Check environment variables: `GENESYSCLOUD_OAUTHCLIENT_ID`, `GENESYSCLOUD_OAUTHCLIENT_SECRET` |
| **Flow/Prompt not found** | Verify exact names in Genesys Cloud or use direct IDs instead |
| **Validation error** | Check email format or state values (must be "active" or "inactive") |
| **Resource already exists** | Check Genesys Cloud for existing resources with same name |
| **Plan shows destroy** | Review moved blocks in main.tf if refactoring happened |

---

## Security Best Practices

1. **Never hardcode credentials** - Use environment variables
2. **Use Terraform Cloud** - For secure state storage
3. **Restrict permissions** - Create roles with minimum needed permissions
4. **Validate inputs** - Always validate user email and state values
5. **Version control** - Track all changes in git
6. **Review plans** - Always run `terraform plan` before `apply`

---

## Summary

This Terraform project provides a scalable, maintainable approach to managing Genesys Cloud infrastructure:

- **Root level** = User-friendly interface for operators
- **Modules** = Reusable, independent components
- **terraform.tfvars** = Single source of truth for configuration
- **Automation** = Consistent, repeatable deployments

For questions or updates, refer to the README.md or project maintainer documentation.

