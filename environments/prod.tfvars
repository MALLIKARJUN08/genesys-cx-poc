# ==========================================
# PROD ENVIRONMENT - ALL RESOURCES
# Deploy everything to PROD
# ==========================================

# Feature Flags - Enable all resources in PROD
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
  "prod_division" = {
    name        = "Production Division"
    description = "Production division"
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
  "prod_support_queue" = {
    name        = "Production Support Queue"
    description = "Support queue in production"
  }
}

# ==========================================
# Users Configuration
# ==========================================
users = {
  "sample_admin" = {
    name  = "Sample Admin"
    email = "admin@production.example.com"
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
    email = "agent@production.example.com"
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
  "prod_supervisor" = {
    name        = "Production Supervisor"
    description = "Supervisor role in production"
  }
}

# ==========================================
# Flows Configuration
# ==========================================
flows = {
  # Example flow configuration - REPLACE WITH YOUR FLOW
  "my_inbound_flow" = {
    name        = "Practice_Flow"
    description = "Practice flow deployed using CICD"
    type        = "inboundcall"
    filepath    = "./flows/Practice_Flow.yaml"
    locked      = true  # Lock flow from editing in UI for production safety
  }
}
