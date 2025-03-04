output "app_id" {
  description = "ID of the created Fly.io application"
  value       = fly_app.app.id
}

output "app_name" {
  description = "Name of the created Fly.io application"
  value       = fly_app.app.name
}

output "app_url" {
  description = "URL of the deployed application"
  value       = "https://${fly_app.app.name}.fly.dev"
}

output "volume_ids" {
  description = "IDs of the created volumes"
  value       = { for region, volume in fly_volume.app_volume : region => volume.id }
}

output "machine_ids" {
  description = "IDs of the created machines"
  value       = { for region, machine in fly_machine.app_machine : region => machine.id }
} 