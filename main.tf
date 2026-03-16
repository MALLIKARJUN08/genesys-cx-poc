resource "genesyscloud_routing_queue" "poc_queue" {
  name        = "Terraform_POC_Queue"
  description = "POC queue created via Terraform"
}

resource "genesyscloud_routing_queue" "automated_queue" {
  name        = "Terraform_Automated_Queue"
  description = "This queue was created automatically via git push!"
}

resource "genesyscloud_routing_queue" "support_queue" {
  name        = "Terraform_Support_Queue"
  description = "A new support queue created via GitHub Actions"
}
