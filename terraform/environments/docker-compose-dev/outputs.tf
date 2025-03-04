output "app_url" {
  description = "The URL of the deployed application"
  value       = module.docker_compose_app.app_url
}

output "app_name" {
  description = "The name of the deployed application"
  value       = module.docker_compose_app.app_name
}

output "app_id" {
  description = "The ID of the deployed application"
  value       = module.docker_compose_app.app_id
}

output "volume_ids" {
  description = "The IDs of the created volumes"
  value       = module.docker_compose_app.volume_ids
}

output "machine_ids" {
  description = "The IDs of the created machines"
  value       = module.docker_compose_app.machine_ids
} 