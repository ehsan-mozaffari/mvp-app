module "fly_app" {
  source   = "./modules/fly-app"
  app_name = var.app_name
  app_org  = var.app_org
}

module "fly_machines" {
  source        = "./modules/fly-machines"
  app_id        = module.fly_app.app_id
  app_name      = module.fly_app.app_name
  app_regions   = var.app_regions
  machine_size  = var.machine_size
  machine_memory = var.machine_memory
  machine_image = "nginx:latest"  # You can customize this or make it a variable
  
  depends_on = [module.fly_app]
}

module "fly_volumes" {
  source      = "./modules/fly-volumes"
  app_id      = module.fly_app.app_id
  app_name    = module.fly_app.app_name
  app_regions = var.app_regions
  volume_size = var.volume_size
  
  depends_on = [module.fly_app]
}

# Optional: Docker Compose deployment module
# Uncomment to use Docker Compose instead of the separate modules above
/*
module "docker_compose_app" {
  source        = "./modules/fly-docker-compose"
  
  app_name      = var.app_name
  app_org       = var.app_org
  app_regions   = var.app_regions
  machine_size  = var.machine_size
  machine_memory = var.machine_memory
  volume_size   = var.volume_size
  fly_api_token = var.fly_api_token
  
  # Docker Compose specific settings
  compose_template_path = "${path.module}/compose.yml.tftpl"
  compose_template_vars = {}
  html_content_path    = "${path.module}/../html"
}
*/ 