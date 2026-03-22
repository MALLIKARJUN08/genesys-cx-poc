variable "users" {
  description = "A map of users to create"
  type = map(object({
    name  = string
    email = string
    state = string
  }))
  default = {}

  validation {
    condition     = alltrue([for u in var.users : contains(["active", "inactive"], u.state)])
    error_message = "User state must be either 'active' or 'inactive'."
  }

  validation {
    condition     = alltrue([for u in var.users : can(regex("^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$", u.email))])
    error_message = "All user emails must be in a valid email format."
  }
}
