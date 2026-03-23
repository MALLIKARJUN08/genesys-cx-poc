# Genesys CX as Code - Automated lookup Configuration
# 🚀 This version uses NAME-BASED lookups.
# ⚠️ IMPORTANT: These names MUST match real resources in your Genesys Org.

queues = {
  "example_queue" = {
    name                    = "Sample_Advanced_Queue"
    description             = "A queue demonstrating automated Name-to-ID lookups"
    acw_wrapup_prompt       = "MANDATORY_TIMEOUT"
    acw_timeout_ms          = 300000
    skill_evaluation_method = "BEST"

    # 🛑 ACTION REQUIRED: Replace these names with REAL resources from your Architect Flows and Prompts
    queue_flow_name     = "First Call Flow" 
    queue_flow_type     = "Inbound Call"
    whisper_prompt_name = "abc"
    group_names         = ["CIC_group"]

    auto_answer_only         = true
    enable_transcription     = true
    enable_audio_monitoring  = true
    enable_manual_assignment = true
    calling_party_name       = "Antigravity Support"

    media_settings_call = {
      alerting_timeout_sec      = 30
      service_level_percentage  = 0.8
      service_level_duration_ms = 20000
    }

    routing_rules = [
      {
        operator     = "MEETS_THRESHOLD"
        threshold    = 5
        wait_seconds = 60
      }
    ]

    bullseye_rings = [
      {
        expansion_timeout_seconds = 15
      },
      {
        expansion_timeout_seconds = 30
        member_groups = [
          {
            member_group_name = "REPLACE_WITH_YOUR_AGENT_GROUP"
            member_group_type = "GROUP"
          }
        ]
      }
    ]

    conditional_group_activation = {
      pilot_rule = {
        condition_expression = "C1"
        conditions = [
          {
            simple_metric = {
              metric = "EstimatedWaitTime"
            }
            operator = "GreaterThan"
            value    = 45
          }
        ]
      }
      rules = [
        {
          condition_expression = "C1"
          conditions = [
            {
              simple_metric = {
                metric = "IdleAgentCount"
              }
              operator = "LessThan"
              value    = 2
            }
          ]
          groups = [
            {
              member_group_name = "REPLACE_WITH_YOUR_OVERFLOW_GROUP"
              member_group_type = "GROUP"
            }
          ]
        }
      ]
    }
  }
}

users = {
  "sample_admin" = {
    name  = "Sample Admin"
    email = "admin@example.com"
    state = "active"
  }
}

roles = {
  "sample_role" = {
    name                = "Sample Role"
    description         = "A basic sample role"
    permissions         = ["routing:queue:view"]
    permission_policies = []
  }
}
