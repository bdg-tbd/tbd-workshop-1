variable "project_name" {
  type = string
}

variable "project_number" {
  type = string
}
variable "env" {
  type = string
}

variable "prefix" {
  type = string
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "machine_type" {
  type    = string
  default = "db-g1-small"
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "mlflow_docker_image_uri" {
  type        = string
  description = "TBD"
}

variable "network" {
  type        = map(any)
  description = "TBD"
}

variable "subnet_name" {
  type        = string
  description = "TBD"
}