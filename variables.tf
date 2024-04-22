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

variable "machine_type_dataproc" {
  type        = string
  default     = "e2-medium"
  description = "Machine type to use for both worker and master nodes for dataproc"
}

variable "machine_type_jupyter" {
  type        = string
  default     = "e2-standard-2"
  description = "Arbitrary machine type for jupyter"
}
