terraform {
  backend "local" {
    path = "terraform.staging.tfstate"
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
  
  # Override default variables for the staging environment
  app_name      = "my-fly-app-staging"
  app_regions   = ["ams", "dfw"]  # Using two regions for staging
  machine_size  = "shared-cpu-1x"
  machine_memory = 512
  volume_size   = 3
} 