# ==========================================
# Flows Module Outputs
# Exposes created flows for use by other modules or root configuration
# ==========================================

output "flow_details" {
  description = "Map of created flows with their IDs and names"
  value = {
    for k, v in genesyscloud_flow.flows : k => {
      id   = v.id
      name = v.name
    }
  }
}

output "flow_ids" {
  description = "Map of flow names to their IDs (useful for referencing in other resources)"
  value = {
    for k, v in genesyscloud_flow.flows : v.name => v.id
  }
}
