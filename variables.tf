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

variable "number_of_worker_machines" {
  type        = number
  default     = 3
  description = "Number of worker instances in dataproc module"
}

variable "number_of_preemptible_machines" {
  type        = number
  default     = 0
  description = "Number of spot instances in dataproc module"
}

