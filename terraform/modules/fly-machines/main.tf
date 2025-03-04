terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
  }
}

resource "fly_machine" "app_machine" {
  for_each = toset(var.app_regions)
  
  app      = var.app_id
  region   = each.value
  name     = "${var.app_name}-${each.value}"
  
  image    = var.machine_image
  
  services = [{
    ports = [{
      port     = 80
      handlers = ["http"]
    }]
    protocol = "tcp"
    internal_port = 8080
  }]
  
  cpus     = var.machine_size == "shared-cpu-1x" ? 1 : 2
  memorymb = var.machine_memory
} 