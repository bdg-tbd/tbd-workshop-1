variable "env_name" {
  type        = string
  description = "Composer env name"
  default     = "demo-lab"
}


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
  description = "VPC to use for notebooks"
}

variable "subnet" {
  type        = string
  description = "VPC subnet used for deployment"
}

variable "image_version" {
  type    = string
  default = "composer-2.4.6-airflow-2.6.3"
}

variable "env_size" {
  type        = string
  description = "Environment size"
  default     = "ENVIRONMENT_SIZE_SMALL"
}