variable "app_id" {
  description = "ID of the Fly.io application"
  type        = string
}

variable "app_name" {
  description = "Name of the Fly.io application"
  type        = string
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

variable "machine_image" {
  description = "Docker image to use for the machine"
  type        = string
  default     = "nginx:latest"
} 