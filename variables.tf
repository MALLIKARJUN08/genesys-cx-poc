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
