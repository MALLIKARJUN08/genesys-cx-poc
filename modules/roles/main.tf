resource "genesyscloud_auth_role" "custom_roles" {
  for_each    = var.roles
  name        = each.value.name
  description = each.value.description
  permissions = each.value.permissions
}
