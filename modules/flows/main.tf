# ==========================================
# Flows Module Main Resource File
# Creates Architect Flows in Genesys Cloud from YAML exports
# Reference: https://registry.terraform.io/providers/MyPureCloud/genesyscloud/latest/docs/resources/flow
# ==========================================

resource "genesyscloud_flow" "flows" {
  for_each = var.flows

  name            = each.value.name
  type            = each.value.type  # "inboundcall", "inboundemail", "inboundshortmessage", etc.
  
  # Read YAML file directly exported from Architect
  filepath        = each.value.filepath

  # Dependencies: Ensure queues and skills exist before creating flows
  depends_on = [var.created_queues, var.created_skills]
}
