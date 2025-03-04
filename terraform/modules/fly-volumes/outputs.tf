output "volume_ids" {
  description = "IDs of the created Fly volumes"
  value       = { for region, volume in fly_volume.app_volume : region => volume.id }
}

output "volume_names" {
  description = "Names of the created Fly volumes"
  value       = { for region, volume in fly_volume.app_volume : region => volume.name }
}

output "volume_regions" {
  description = "Regions where volumes are deployed"
  value       = keys(fly_volume.app_volume)
} 