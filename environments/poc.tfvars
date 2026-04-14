# ==========================================
# POC ENVIRONMENT - ALL RESOURCES
# Deploy skills, users, queues, divisions, roles, and flows to POC
# ==========================================

# Feature Flags - Enable all resources in POC for testing
create_divisions = true
create_skills    = true
create_users     = true
create_queues    = true
create_roles     = true
create_flows     = true

# ==========================================
# Divisions Configuration
# ==========================================
divisions = {
  "poc_division" = {
    name        = "POC Division"
    description = "POC testing division"
    home        = false
  }
}

# ==========================================
# Skills Configuration
# ==========================================
skills = {
  "Changed_Skill" = {
    name = "Changed_Skill"
  }
  "CICD_Skill" = {
    name = "CICD_Skill"
  }
}

# ==========================================
# Queues Configuration
# ==========================================
queues = {
  "poc_support_queue" = {
    name        = "POC Support Queue"
    description = "Support queue in POC environment"
  }
}

# ==========================================
# Users Configuration
# ==========================================
users = {
  "sample_admin" = {
    name  = "Sample Admin"
    email = "admin@poc.example.com"
    state = "active"
    routing_skills = [
      {
        skill_name  = "Changed_Skill"
        proficiency = 4.5
      }
    ]
  }
  "sample_agent" = {
    name  = "Sample Agent"
    email = "agent@poc.example.com"
    state = "active"
    routing_skills = [
      {
        skill_name  = "Changed_Skill"
        proficiency = 4.5
      },
      {
        skill_name  = "CICD_Skill"
        proficiency = 3
      }
    ]
  }
}

# ==========================================
# Roles Configuration
# ==========================================
roles = {
  "poc_supervisor" = {
    name        = "POC Supervisor"
    description = "Supervisor role in POC"
  }
}

# ==========================================
# Flows Configuration
# Add your architect flows here
# 
# How to add your flow:
# 1. Export flow from Architect: Publish → Export → YAML
# 2. Save exported YAML to: ./flows/YOUR_FLOW_NAME.yaml
# 3. Uncomment and update the example below
# 4. Run: terraform apply -var-file="environments/poc.tfvars"
# 
# Terraform will ONLY create new flows (existing resources already in state)
# ==========================================
flows = {
  # UNCOMMENT AND UPDATE THIS EXAMPLE:
  "my_inbound_flow" = {
    name        = "Practice_Flow"
    description = "Practice flow deployed using CICD"
    type        = "inboundcall"
    filepath    = "./flows/Practice_Flow.yaml"
    locked      = false  # Allow editing in POC for testing
  }
}
