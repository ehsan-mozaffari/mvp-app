terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
  }
}

resource "fly_volume" "app_volume" {
  for_each = toset(var.app_regions)
  
  name       = "${replace(var.app_name, "-", "_")}_volume_${each.value}"
  app        = var.app_id
  region     = each.value
  size       = var.volume_size
} 