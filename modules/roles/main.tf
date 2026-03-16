resource "genesyscloud_auth_role" "custom_roles" {
  for_each    = var.roles
  name        = each.value.name
  description = each.value.description
  permissions = each.value.permissions

  dynamic "permission_policies" {
    for_each = each.value.permission_policies
    content {
      domain      = permission_policies.value.domain
      entity_name = permission_policies.value.entity_name
      action_set  = permission_policies.value.action_set
    }
  }
}
