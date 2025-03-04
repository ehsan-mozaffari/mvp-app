terraform {
  backend "local" {
    path = "terraform.prod.tfstate"
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
  
  # Override default variables for the production environment
  app_name      = "my-fly-app"  # No suffix for production
  app_regions   = ["ams", "dfw", "lax"]  # Using all regions for production
  machine_size  = "dedicated-cpu-1x"  # Dedicated CPU for production
  machine_memory = 1024
  volume_size   = 10
} 