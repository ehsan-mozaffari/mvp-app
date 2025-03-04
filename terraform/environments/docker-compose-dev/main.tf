terraform {
  backend "local" {
    path = "terraform.docker-compose-dev.tfstate"
  }
  
  required_providers {
    fly = {
      source  = "fly-apps/fly"
      version = "~> 0.0.23"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.0"
    }
  }
}

provider "fly" {
  fly_api_token = var.fly_api_token
}

# Use our docker-compose module directly
module "docker_compose_app" {
  source = "../../modules/fly-docker-compose"
  
  # Authentication token for Fly.io API
  fly_api_token = var.fly_api_token
  
  # App configuration
  app_name      = "docker-nginx-dev"
  app_org       = "personal"
  app_regions   = ["ams"]  # Using only one region for dev
  
  # Machine configuration
  machine_size   = "shared-cpu-1x"
  machine_memory = 256
  
  # Volume configuration
  volume_size    = 1
  
  # Docker Compose configuration
  compose_template_path = "${path.module}/../../modules/fly-docker-compose/compose.yml.tftpl"
  compose_template_vars = {}
  html_content_path     = "${path.module}/../../../html"
}

# This resource will be triggered whenever the volumes are created/updated
resource "null_resource" "upload_html_content" {
  for_each = toset(module.docker_compose_app.volume_ids != null ? keys(module.docker_compose_app.volume_ids) : [])
  
  triggers = {
    volume_id = module.docker_compose_app.volume_ids[each.key]
  }
  
  provisioner "local-exec" {
    command = templatefile("${path.module}/../../modules/fly-docker-compose/upload_content.sh.tftpl", {
      app_name    = module.docker_compose_app.app_name
      region      = each.key
      volume_id   = module.docker_compose_app.volume_ids[each.key]
      content_path = "${path.module}/../../../html"
    })
    interpreter = ["/bin/bash", "-c"]
  }
  
  depends_on = [module.docker_compose_app]
} 