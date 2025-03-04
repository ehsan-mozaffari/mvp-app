terraform {
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
  }
}

# Local resource to create a compressed archive of the HTML files
resource "local_file" "compose_file" {
  content  = templatefile(var.compose_template_path, var.compose_template_vars)
  filename = "${path.module}/compose.yml"
}

# Create the Fly.io app
resource "fly_app" "app" {
  name = var.app_name
  org  = var.app_org
}

# Create volumes for the app
resource "fly_volume" "app_volume" {
  for_each = toset(var.app_regions)
  
  name       = "${replace(var.app_name, "-", "_")}_data_${each.value}"
  app        = fly_app.app.id
  region     = each.value
  size       = var.volume_size
}

# Deploy machines with Docker Compose
resource "fly_machine" "app_machine" {
  for_each = toset(var.app_regions)
  
  app      = fly_app.app.id
  region   = each.value
  name     = "${var.app_name}-${each.value}"
  
  # Use the nginx image directly as that's what our compose file uses
  image    = "nginx:alpine"
  
  # Mount volumes to the machine
  mounts = [
    {
      source      = fly_volume.app_volume[each.value].id
      destination = "/usr/share/nginx/html"
    }
  ]
  
  services = [{
    ports = [{
      port     = 80
      handlers = ["http"]
    }]
    protocol = "tcp"
    internal_port = 80  # Nginx uses port 80 internally
  }]
  
  cpus     = var.machine_size == "shared-cpu-1x" ? 1 : 2
  memorymb = var.machine_memory
} 