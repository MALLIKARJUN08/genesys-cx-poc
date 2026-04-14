# ==========================================
# Flows Module Variables
# Reference: https://registry.terraform.io/providers/MyPureCloud/genesyscloud/latest/docs/resources/flow#argument-reference
# ==========================================

variable "flows" {
  description = "Map of Architect Flows to deploy (YAML format from Architect export)"
  type = map(object({
    name        = string                # Flow display name in Genesys Cloud
    description = optional(string)      # Flow description
    type        = string                # Type of flow: "inboundcall", "inboundemail", "inboundshortmessage", "outboundcall", "inqueuecall", etc.
    filepath    = string                # Path to YAML file exported from Architect (e.g., "./flows/my_flow.yaml")
    locked      = optional(bool, false) # Lock flow from editing in UI (true for production, false for testing)
  }))
  default = {}
}

variable "created_queues" {
  description = "Map of created queues for flow dependencies (from queues module output)"
  type        = map(any)
  default     = {}
}

variable "created_skills" {
  description = "Map of created skills for flow dependencies (from skills module output)"
  type        = map(any)
  default     = {}
}
