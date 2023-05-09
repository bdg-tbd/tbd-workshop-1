variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "ai_notebook_instance_owner" {
  type        = string
  description = "Vertex AI workbench owner"
}

variable "ai_notebook_image_repository" {
  type    = string
  default = "gcr.io/deeplearning-platform-release/base-cpu.py310"
}

variable "ai_notebook_image_tag" {
  type    = string
  default = "latest"
}