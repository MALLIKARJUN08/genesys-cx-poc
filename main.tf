resource "genesyscloud_routing_queue" "poc_queue" {
  name        = "Terraform_POC_Queue"
  description = "POC queue created via Terraform"
}
