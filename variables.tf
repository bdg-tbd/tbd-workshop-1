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

variable "dataproc_master_num_instances" {
  type        = number
  default     = 1
  description = "Number of master nodes"
}

variable "dataproc_master_machine_type" {
  type        = string
  description = "Machine type to use for master nodes in Dataproc cluster"
  default     = "e2-standard-2"
}

variable "dataproc_worker_num_instances" {
  type        = number
  default     = 2
  description = "Number of worker nodes"
}

variable "dataproc_worker_machine_type" {
  type        = string
  description = "Machine type to use for worker nodes in Dataproc cluster"
  default     = "e2-standard-2"
}

variable "ai_notebook_machine_type" {
  type    = string
  default = "e2-standard-2"
}
