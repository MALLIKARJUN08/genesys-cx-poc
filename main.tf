# ==========================================
# Root Module Calls - With Feature Flags
# These blocks instantiate the child modules located in the ./modules directory.
# Feature flags control which resources are created per deployment scenario.
# ==========================================

# 1. Divisions Module
# This module dynamically creates Divisions in Genesys Cloud.
module "divisions" {
  count     = var.create_divisions ? 1 : 0
  source    = "./modules/divisions"
  divisions = var.divisions
}

# 2. Skills Module
# This module dynamically creates Routing Skills in Genesys Cloud.
module "skills" {
  count  = var.create_skills ? 1 : 0
  source = "./modules/skills"
  skills = var.skills
}

# 3. Queues Module
# Creates queues with routing rules and dependencies on divisions and users.
module "queues" {
  count             = var.create_queues ? 1 : 0
  source            = "./modules/queues"
  queues            = var.queues
  created_divisions = var.create_divisions ? module.divisions[0].division_details : {}
  created_users     = var.create_users ? module.users[0].user_details : {}
}

# 4. Users Module
# Creates user accounts with routing skills assigned.
module "users" {
  count          = var.create_users ? 1 : 0
  source         = "./modules/users"
  users          = var.users
  created_skills = var.create_skills ? module.skills[0].skill_details : {}
}

# 5. Roles Module
# Creates authorization roles for Genesys Cloud.
module "roles" {
  count  = var.create_roles ? 1 : 0
  source = "./modules/roles"
  roles  = var.roles
}

# 6. Flows Module
# Creates Architect flows deployed to Genesys Cloud.
# Can be deployed independently of other resources.
module "flows" {
  count          = var.create_flows ? 1 : 0
  source         = "./modules/flows"
  flows          = var.flows
  created_queues = var.create_queues ? module.queues[0].queue_details : {}
  created_skills = var.create_skills ? module.skills[0].skill_details : {}
}

# ==========================================
# State Migration (Moved Blocks)
# 
# These "moved" blocks tell Terraform state management that we have refactored our code.
# Previously, resources were created as individual objects (e.g., `poc_queue`).
# We refactored the code to use a `for_each` loop (e.g., `queues["poc_queue"]`).
# These blocks prevent Terraform from destroying the old resource and recreating it,
# instructing it instead to simply rename the address in the state file.
# ==========================================

moved {
  from = module.queues.genesyscloud_routing_queue.poc_queue
  to   = module.queues.genesyscloud_routing_queue.queues["poc_queue"]
}

moved {
  from = module.queues.genesyscloud_routing_queue.automated_queue
  to   = module.queues.genesyscloud_routing_queue.queues["automated_queue"]
}

moved {
  from = module.queues.genesyscloud_routing_queue.support_queue
  to   = module.queues.genesyscloud_routing_queue.queues["support_queue"]
}

moved {
  from = module.queues.genesyscloud_routing_queue.technical_queue
  to   = module.queues.genesyscloud_routing_queue.queues["technical_queue"]
}

moved {
  from = module.users.genesyscloud_user.example_user
  to   = module.users.genesyscloud_user.users["example_user"]
}

