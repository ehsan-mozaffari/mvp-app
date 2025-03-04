variable "app_name" {
  description = "Name of the Fly.io application"
  type        = string
}

variable "app_org" {
  description = "Fly.io organization name"
  type        = string
  default     = "personal"
}

variable "app_regions" {
  description = "Regions where the app will be deployed"
  type        = list(string)
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

variable "compose_template_path" {
  description = "Path to the Docker Compose template file"
  type        = string
  default     = "compose.yml.tftpl"
}

variable "compose_template_vars" {
  description = "Variables to pass to the Docker Compose template"
  type        = map(any)
  default     = {}
}

variable "html_content_path" {
  description = "Path to the HTML content to be mounted"
  type        = string
  default     = "html"
}

variable "fly_api_token" {
  description = "Fly.io API token for authentication"
  type        = string
  sensitive   = true
} 