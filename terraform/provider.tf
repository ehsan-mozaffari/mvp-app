terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"  # Use the appropriate version
    }
  }
  required_version = ">= 1.0.0"
}

# The provider configuration will come from the child modules
# Removed the redundant empty provider block 