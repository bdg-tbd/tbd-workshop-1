variable "registry_hostname" {
  type        = string
  description = "Image registry hostname"
}

variable "registry_repo_name" {
  type        = string
  description = "Image registry repository name"
}

variable "jupyterlab_version" {
  type        = string
  description = "Jupyterlab version"
  default     = "3.6.3"
}

variable "project_name" {
  type        = string
  description = "Project name"
}
