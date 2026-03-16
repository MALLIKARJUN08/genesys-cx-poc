output "queues" {
  description = "Consolidated details of all created queues"
  value       = module.queues.queue_details
}

output "users" {
  description = "Consolidated details of all created users"
  value       = module.users.user_details
}
