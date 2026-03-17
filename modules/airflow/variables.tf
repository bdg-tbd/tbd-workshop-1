variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "network" {
  type        = string
  description = "VPC network name"
}

variable "subnet" {
  type        = string
  description = "VPC subnet self_link"
}

variable "machine_type" {
  type        = string
  default     = "e2-standard-2"
  description = "Machine type for GKE nodes"
}
