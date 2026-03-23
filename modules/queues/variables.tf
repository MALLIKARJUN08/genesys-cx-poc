variable "queues" {
  description = "Queues to be passed to the genesyscloud_routing_queue resource"
  type = map(object({
    name                     = string
    description              = optional(string)
    division_id              = optional(string)
    acw_wrapup_prompt        = optional(string)
    acw_timeout_ms           = optional(number)
    skill_evaluation_method  = optional(string)
    queue_flow_id            = optional(string)
    queue_flow_name          = optional(string)
    queue_flow_type          = optional(string, "Inbound Call")
    whisper_prompt_id        = optional(string)
    whisper_prompt_name      = optional(string)
    auto_answer_only         = optional(bool)
    enable_transcription     = optional(bool)
    enable_audio_monitoring  = optional(bool)
    enable_manual_assignment = optional(bool)
    calling_party_name       = optional(string)
    groups                   = optional(list(string))
    group_names              = optional(list(string))
    wrapup_codes             = optional(list(string))
    default_script_ids       = optional(map(string))
    outbound_email_address = optional(object({
      domain_id = string
      route_id  = string
    }))
    media_settings_call = optional(object({
      alerting_timeout_sec      = optional(number)
      service_level_percentage  = optional(number)
      service_level_duration_ms = optional(number)
    }))
    routing_rules = optional(list(object({
      operator     = string
      threshold    = number
      wait_seconds = number
    })))
    bullseye_rings = optional(list(object({
      expansion_timeout_seconds = number
      skills_to_remove          = optional(list(string))
      member_groups = optional(list(object({
        member_group_id   = optional(string)
        member_group_name = optional(string)
        member_group_type = string
      })))
    })))
    conditional_group_activation = optional(object({
      pilot_rule = optional(object({
        condition_expression = string
        conditions = list(object({
          simple_metric = object({
            metric   = string
            queue_id = optional(string)
          })
          operator = string
          value    = number
        }))
      }))
      rules = optional(list(object({
        condition_expression = string
        conditions = list(object({
          simple_metric = object({
            metric   = string
            queue_id = optional(string)
          })
          operator = string
          value    = number
        }))
        groups = list(object({
          member_group_id   = optional(string)
          member_group_name = optional(string)
          member_group_type = string
        }))
      })))
    }))
    members = optional(list(object({
      user_id  = string
      ring_num = number
    })))
  }))
}
