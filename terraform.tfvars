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
  }
}

users = {
  "example_user" = {
    name  = "Terraform POC User"
    email = "terraform_poc_user@example.com"
    state = "active"
  }
}
