terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
  }
}

resource "fly_app" "app" {
  name = var.app_name
  org  = var.app_org
} 