queues = {
  "poc_queue" = {
    name        = "Terraform_POC_Queue"
    description = "POC queue created via Terraform"
  },
  "automated_queue" = {
    name        = "Terraform_Automated_Queue"
    description = "This queue was created automatically via git push!"
  },
  "support_queue" = {
    name        = "Terraform_Support_Queue"
    description = "A new support queue created via GitHub Actions"
  },
  "technical_queue" = {
    name        = "Technical_Queue"
    description = "A new technical queue created via GitHub Actions"
  },
  "innovation_queue" = {
    name        = "Innovation_Queue"
    description = "A new queue demonstrating dynamic variable-driven creation!"
  }
}

users = {
  "example_user" = {
    name  = "Terraform POC User"
    email = "terraform_poc_user@example.com"
    state = "active"
  },
  "jane_doe" = {
    name  = "Jane Doe"
    email = "jane.doe@example.com"
    state = "active"
  }
}

roles = {
  "support_tier_1" = {
    name        = "Support Tier 1"
    description = "Custom role for first level support agents"
    permissions = [
      "routing_queue_view",
      "routing_queue_join",
      "directory_user_view",
      "directory_user_search",
      "conversation_message_view",
      "conversation_call_view",
      "alerting_interaction_view"
    ]
  }
}
