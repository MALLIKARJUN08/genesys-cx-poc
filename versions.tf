terraform {
  required_version = ">= 1.0.0"

  required_providers {
    genesyscloud = {
      source  = "mypurecloud/genesyscloud"
      version = "~> 1.40" # It's generally best to pin to a minor version; update this to latest if necessary
    }
  }

  cloud {
    organization = "cg_genesys"
    workspaces {
      tags = ["genesys-cx"]
    }
  }
}

provider "genesyscloud" {
  # The provider is configured here, but the actual authentication credentials
  # should never be hardcoded. They will be securely passed via Environment Variables 
  # in Terraform Cloud:
  # - GENESYSCLOUD_OAUTHCLIENT_ID
  # - GENESYSCLOUD_OAUTHCLIENT_SECRET
  # - GENESYSCLOUD_REGION (e.g., "us-east-1", "eu-west-1", "ap-southeast-2")
}
