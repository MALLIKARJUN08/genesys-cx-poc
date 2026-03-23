# Genesys CX as Code - Sample Data Configuration
# Use this file to test the syntax and structure of your advanced queue configurations.
# ⚠️ NOTE: Replace the placeholder UUIDs (0a0a0a0a-...) with real IDs from your Genesys Org.

queues = {
  "example_queue" = {
    name                     = "Sample_Advanced_Queue"
    description              = "A queue demonstrating all advanced Terraform configurations"
    acw_wrapup_prompt        = "MANDATORY_TIMEOUT"
    acw_timeout_ms           = 300000
    skill_evaluation_method  = "BEST"
    queue_flow_id            = "11111111-2222-3333-4444-555555555555" # Placeholder Flow ID
    whisper_prompt_id        = "66666666-7777-8888-9999-000000000000" # Placeholder Prompt ID
    auto_answer_only         = true
    enable_transcription     = true
    enable_audio_monitoring  = true
    enable_manual_assignment = true
    calling_party_name       = "Antigravity Support"
    groups                   = ["aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"] # Placeholder Group ID

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
      },
      {
        operator     = "MEETS_THRESHOLD"
        threshold    = 2
        wait_seconds = 120
      }
    ]

    bullseye_rings = [
      {
        expansion_timeout_seconds = 15
        skills_to_remove          = ["bbbbbbbb-cccc-dddd-eeee-ffffffffffff"] # Placeholder Skill ID
      },
      {
        expansion_timeout_seconds = 30
        member_groups = [
          {
            member_group_id   = "cccccccc-dddd-eeee-ffff-000000000000" # Placeholder Group ID
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
              member_group_id   = "dddddddd-eeee-ffff-0000-111111111111" # Placeholder Group ID
              member_group_type = "GROUP"
            }
          ]
        }
      ]
    }

    wrapup_codes = ["eeeeeeee-ffff-0000-1111-222222222222"] # Placeholder Wrapup ID
    members = [
      {
        user_id = "ffffffff-0000-1111-2222-333333333333" # Placeholder User ID
        ring    = 1
      }
    ]
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
