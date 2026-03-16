variable "roles" {
  description = "A map of custom roles to create"
  type = map(object({
    name        = string
    description = string
    permissions = list(string)
  }))
  default = {}
}
