variable "registry_hostname" {
  type        = string
  description = "Image registry hostname"
}

variable "registry_repo_name" {
  type        = string
  description = "Image registry repository name"
}

variable "mlflow_version" {
  type        = string
  description = "MLflow version"
  default     = "2.3.1"
}