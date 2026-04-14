# ==========================================
# Roles Module Variables
# Defines the exact object structure required to build a Genesys Cloud Role.
# ==========================================

variable "roles" {
  description = "A map of custom roles to create"
  type = map(object({
    name        = string                     # Internal name
    description = optional(string)           # Description of what the role can do
    permissions = optional(list(string), []) # The array of permission scopes to grant
  }))
  default = {} # Default to empty if nothing is passed
}

