resource "genesyscloud_user" "users" {
  for_each = var.users
  name     = each.value.name
  email    = each.value.email
  state    = each.value.state
}
