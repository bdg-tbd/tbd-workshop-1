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