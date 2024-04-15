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

variable "dataproc_num_workers" {
  type    = number
  default = 2
}

variable "dataproc_machine_type" {
  type    = string
  default = "e2-standard-2"
}

variable "notebook_machine_type" {
  type    = string
  default = "e2-standard-2"
}