output "user_details" {
  description = "A map of user names and their IDs"
  value = {
    for k, v in genesyscloud_user.users : k => {
      name  = v.name
      email = v.email
      id    = v.id
    }
  }
}
