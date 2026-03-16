module "queues" {
  source = "./modules/queues"
}

module "users" {
  source = "./modules/users"
}

moved {
  from = genesyscloud_routing_queue.poc_queue
  to   = module.queues.genesyscloud_routing_queue.poc_queue
}

moved {
  from = genesyscloud_routing_queue.automated_queue
  to   = module.queues.genesyscloud_routing_queue.automated_queue
}

moved {
  from = genesyscloud_routing_queue.support_queue
  to   = module.queues.genesyscloud_routing_queue.support_queue
}

moved {
  from = genesyscloud_routing_queue.technical_queue
  to   = module.queues.genesyscloud_routing_queue.technical_queue
}
