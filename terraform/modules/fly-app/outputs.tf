output "app_id" {
  description = "The ID of the Fly.io application"
  value       = fly_app.app.id
}

output "app_name" {
  description = "The name of the Fly.io application"
  value       = fly_app.app.name
} 