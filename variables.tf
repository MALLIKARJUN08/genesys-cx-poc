variable "queues" {
  description = "Queues to be passed to the queues module"
  type = map(object({
    name        = string
    description = string
  }))
}

variable "users" {
  description = "Users to be passed to the users module"
  type = map(object({
    name  = string
    email = string
    state = string
  }))
}

variable "roles" {
  description = "Roles to be passed to the roles module"
  type = map(object({
    name        = string
    description = string
    permissions = list(string)
  }))
}
