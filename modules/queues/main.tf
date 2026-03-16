resource "genesyscloud_routing_queue" "queues" {
  for_each    = var.queues
  name        = each.value.name
  description = each.value.description
}
