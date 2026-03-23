data "genesyscloud_auth_division_home" "home" {}

resource "genesyscloud_routing_queue" "queues" {
  for_each = var.queues

  name                     = each.value.name
  description              = each.value.description
  division_id              = each.value.division_id != null ? each.value.division_id : data.genesyscloud_auth_division_home.home.id
  acw_wrapup_prompt        = each.value.acw_wrapup_prompt
  acw_timeout_ms           = each.value.acw_timeout_ms
  skill_evaluation_method  = each.value.skill_evaluation_method
  queue_flow_id            = each.value.queue_flow_id
  whisper_prompt_id        = each.value.whisper_prompt_id
  auto_answer_only         = each.value.auto_answer_only
  enable_transcription     = each.value.enable_transcription
  enable_audio_monitoring  = each.value.enable_audio_monitoring
  enable_manual_assignment = each.value.enable_manual_assignment
  calling_party_name       = each.value.calling_party_name
  groups                   = each.value.groups
  wrapup_codes             = each.value.wrapup_codes
  default_script_ids       = each.value.default_script_ids

  dynamic "outbound_email_address" {
    for_each = each.value.outbound_email_address != null ? [each.value.outbound_email_address] : []
    content {
      domain_id = outbound_email_address.value.domain_id
      route_id  = outbound_email_address.value.route_id
    }
  }

  dynamic "media_settings_call" {
    for_each = each.value.media_settings_call != null ? [each.value.media_settings_call] : []
    content {
      alerting_timeout_sec      = media_settings_call.value.alerting_timeout_sec
      service_level_percentage  = media_settings_call.value.service_level_percentage
      service_level_duration_ms = media_settings_call.value.service_level_duration_ms
    }
  }

  dynamic "routing_rules" {
    for_each = each.value.routing_rules != null ? each.value.routing_rules : []
    content {
      operator     = routing_rules.value.operator
      threshold    = routing_rules.value.threshold
      wait_seconds = routing_rules.value.wait_seconds
    }
  }

  dynamic "bullseye_rings" {
    for_each = each.value.bullseye_rings != null ? each.value.bullseye_rings : []
    content {
      expansion_timeout_seconds = bullseye_rings.value.expansion_timeout_seconds
      skills_to_remove          = bullseye_rings.value.skills_to_remove
      dynamic "member_groups" {
        for_each = bullseye_rings.value.member_groups != null ? bullseye_rings.value.member_groups : []
        content {
          member_group_id   = member_groups.value.member_group_id
          member_group_type = member_groups.value.member_group_type
        }
      }
    }
  }

  dynamic "conditional_group_activation" {
    for_each = each.value.conditional_group_activation != null ? [each.value.conditional_group_activation] : []
    content {
      dynamic "pilot_rule" {
        for_each = conditional_group_activation.value.pilot_rule != null ? [conditional_group_activation.value.pilot_rule] : []
        content {
          condition_expression = pilot_rule.value.condition_expression
          dynamic "conditions" {
            for_each = pilot_rule.value.conditions
            content {
              dynamic "simple_metric" {
                for_each = [conditions.value.simple_metric]
                content {
                  metric   = simple_metric.value.metric
                  queue_id = simple_metric.value.queue_id
                }
              }
              operator = conditions.value.operator
              value    = conditions.value.value
            }
          }
        }
      }
      dynamic "rules" {
        for_each = conditional_group_activation.value.rules != null ? conditional_group_activation.value.rules : []
        content {
          condition_expression = rules.value.condition_expression
          dynamic "conditions" {
            for_each = rules.value.conditions
            content {
              dynamic "simple_metric" {
                for_each = [conditions.value.simple_metric]
                content {
                  metric   = simple_metric.value.metric
                  queue_id = simple_metric.value.queue_id
                }
              }
              operator = conditions.value.operator
              value    = conditions.value.value
            }
          }
          dynamic "groups" {
            for_each = rules.value.groups
            content {
              member_group_id   = groups.value.member_group_id
              member_group_type = groups.value.member_group_type
            }
          }
        }
      }
    }
  }

  dynamic "members" {
    for_each = each.value.members != null ? each.value.members : []
    content {
      user_id  = members.value.user_id
      ring_num = members.value.ring_num
    }
  }
}
