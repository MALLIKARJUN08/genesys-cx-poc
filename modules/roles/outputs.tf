output "role_details" {
  description = "A map of role names and their IDs"
  value = {
    for k, v in genesyscloud_auth_role.custom_roles : k => {
      name = v.name
      id   = v.id
    }
  }
}
