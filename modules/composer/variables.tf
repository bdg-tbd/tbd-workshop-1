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

variable "subnet_address" {
  type        = string
  description = "VPC subnet used for deployment"
}

variable "subnet_name" {
  type        = string
  description = "Composer subnet name"
  default     = "composer-subnet-01"
}

variable "image_version" {
  type    = string
  default = "composer-2.11.5-airflow-2.9.3"
}

variable "env_size" {
  type        = string
  description = "Environment size"
  default     = "ENVIRONMENT_SIZE_SMALL"
}

variable "env_variables" {
  type        = map(string)
  description = "Apache Airflow variables to set"
}