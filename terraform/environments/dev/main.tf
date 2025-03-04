terraform {
  backend "local" {
    path = "terraform.dev.tfstate"
  }
  
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
  }
}

provider "fly" {
  fly_api_token = var.fly_api_token
}

module "fly_infrastructure" {
  source = "../../"
  
  # Authentication token for Fly.io API
  fly_api_token = var.fly_api_token
  
  # Override default variables for the dev environment
  app_name      = "my-fly-app-dev"
  app_regions   = ["ams"]  # Using only one region for dev to save costs
  machine_size  = "shared-cpu-1x"
  machine_memory = 256
  volume_size   = 1
} 