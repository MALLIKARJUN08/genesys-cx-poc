# ==========================================
# Terraform Core and Provider Configuration
# This file dictates the versions of Terraform and Providers required,
# and configures the backend where state is stored.
# ==========================================

terraform {
  # Forces anyone running this code to use at least Terraform v1.0.0
  required_version = ">= 1.0.0"

  required_providers {
    # The Genesys Cloud CX Provider block
    genesyscloud = {
      source  = "mypurecloud/genesyscloud" # The official repository for the provider
      version = "~> 1.40"                  # Use version 1.40.x (avoids breaking changes in 2.0)
    }
  }

  # Terraform Cloud Backend Configuration
  # TEMPORARILY DISABLED FOR LOCAL STATE POC TESTING
  # Re-enable after POC validation for CI/CD
  # cloud {
  #   organization = "cg_genesys" # The HCP Terraform Organization name
  #   workspaces {
  #     # This tag logic allows us to use multiple workspaces (e.g., genesys-cx-poc, genesys-cx-prod)
  #     # without hardcoding a single workspace name.
  #     tags = ["genesys-cx"]
  #   }
  # }
}

# Provider Initialization

provider "genesyscloud" {
  oauthclient_id     = "0f667a85-4755-4fcc-88d1-e86ce835303f"
  oauthclient_secret = "5lvUUn4aEpGhv6sWguw6V5emnuKcHLi5A3V2sVlLvZY"
  aws_region         = "us-west-2"
}

