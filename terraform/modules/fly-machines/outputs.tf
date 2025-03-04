output "machine_ids" {
  description = "IDs of the created Fly machines"
  value       = { for region, machine in fly_machine.app_machine : region => machine.id }
}

output "machine_names" {
  description = "Names of the created Fly machines"
  value       = { for region, machine in fly_machine.app_machine : region => machine.name }
}

output "machine_regions" {
  description = "Regions where machines are deployed"
  value       = keys(fly_machine.app_machine)
} 