output "app_name" {
  description = "The name of the Fly.io application"
  value       = var.app_name
}

output "app_url" {
  description = "The URL of the deployed application"
  value       = "${var.app_name}.fly.dev"
}

output "app_regions" {
  description = "Regions where the app is deployed"
  value       = var.app_regions
}

output "machine_count" {
  description = "Number of machines deployed"
  value       = length(var.app_regions)  # Assuming one machine per region
} 