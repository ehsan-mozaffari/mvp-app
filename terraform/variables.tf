variable "fly_api_token" {
  description = "Fly.io API token for authentication"
  type        = string
  sensitive   = true
  # Default value is not set - will be provided via environment variable or .tfvars file
}

variable "app_name" {
  description = "Name of the Fly.io application"
  type        = string
  default     = "my-fly-app"
}

variable "app_org" {
  description = "Fly.io organization name"
  type        = string
  default     = "personal"
}

variable "app_regions" {
  description = "Regions where the app will be deployed"
  type        = list(string)
  default     = ["ams", "dfw", "lax"]  # Amsterdam, Dallas, Los Angeles
}

variable "machine_size" {
  description = "VM size for the Fly machines"
  type        = string
  default     = "shared-cpu-1x"
}

variable "machine_memory" {
  description = "Memory for Fly machines in MB"
  type        = number
  default     = 256
}

variable "volume_size" {
  description = "Size of attached volumes in GB"
  type        = number
  default     = 1
} 