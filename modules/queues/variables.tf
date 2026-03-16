variable "queues" {
  description = "A map of queues to create"
  type = map(object({
    name        = string
    description = string
  }))
  default = {}
}
