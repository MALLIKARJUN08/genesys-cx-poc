resource "genesyscloud_user" "example_user" {
  email = "terraform_poc_user@example.com"
  name  = "Terraform POC User"
  state = "active"
}
