variable "users" {
  description = "A map of users to create"
  type = map(object({
    name  = string
    email = string
    state = string
  }))
  default = {}
}
