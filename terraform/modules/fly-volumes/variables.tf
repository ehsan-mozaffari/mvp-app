variable "app_id" {
  description = "ID of the Fly.io application"
  type        = string
}

variable "app_name" {
  description = "Name of the Fly.io application"
  type        = string
}

variable "app_regions" {
  description = "Regions where the volumes will be deployed"
  type        = list(string)
}

variable "volume_size" {
  description = "Size of volumes in GB"
  type        = number
  default     = 1
} 