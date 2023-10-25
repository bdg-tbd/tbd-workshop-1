variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "network_name" {
  type        = string
  description = "VPC name"
}

variable "subnet_name" {
  type        = string
  description = "VPC subnet name"
}

variable "subnet_address" {
  type    = string
  default = "10.10.10.0/24"
}