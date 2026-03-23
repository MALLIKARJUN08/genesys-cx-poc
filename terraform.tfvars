# Genesys CX as Code - Automated lookup Configuration
# 🚀 This version uses NAME-BASED lookups to avoid manual ID entry.
# If a name is provided, Terraform will automatically find the matching ID in your Org.

queues = {
  "example_queue" = {
    name                     = "Sample_Advanced_Queue"
    description              = "A queue demonstrating automated Name-to-ID lookups"
    acw_wrapup_prompt        = "MANDATORY_TIMEOUT"
    acw_timeout_ms           = 300000
    skill_evaluation_method  = "BEST"
    
    # Automated Lookups (Replaces manual UUIDs)
    queue_flow_name          = "Default In-Queue Call Flow" # Terraform finds this by name
    whisper_prompt_name      = "Default Whisper Prompt"     # Terraform finds this by name
    group_names              = ["Contact Center Agents"]    # Terraform finds these by name

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
        # skills_to_remove still requires IDs currently unless we add skill_names
      },
      {
        expansion_timeout_seconds = 30
        member_groups = [
          {
            member_group_name = "Contact Center Agents" # Replaced dummy ID
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
              member_group_name = "Support Agents" # Replaced dummy ID
              member_group_type = "GROUP"
            }
          ]
        }
      ]
    }
    
    # Note: Wrapup codes and direct members still use IDs for precision
    # wrapup_codes = ["..."] 
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
