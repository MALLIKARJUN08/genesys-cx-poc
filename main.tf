module "queues" {
  source = "./modules/queues"
  queues = var.queues
}

module "users" {
  source = "./modules/users"
  users  = var.users
}

# Mapping old addresses to new for_each addresses to prevent resource recreation
moved {
  from = module.queues.genesyscloud_routing_queue.poc_queue
  to   = module.queues.genesyscloud_routing_queue.queues["poc_queue"]
}

moved {
  from = module.queues.genesyscloud_routing_queue.automated_queue
  to   = module.queues.genesyscloud_routing_queue.queues["automated_queue"]
}

moved {
  from = module.queues.genesyscloud_routing_queue.support_queue
  to   = module.queues.genesyscloud_routing_queue.queues["support_queue"]
}

moved {
  from = module.queues.genesyscloud_routing_queue.technical_queue
  to   = module.queues.genesyscloud_routing_queue.queues["technical_queue"]
}

moved {
  from = module.users.genesyscloud_user.example_user
  to   = module.users.genesyscloud_user.users["example_user"]
}
