variable "roles" {
  description = "A map of custom roles to create"
  type = map(object({
    name        = string
    description = string
    permissions = list(string)
    permission_policies = list(object({
      domain      = string
      entity_name = string
      action_set  = list(string)
    }))
  }))
  default = {}
}
