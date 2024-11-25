variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "subnet" {
  type        = string
  description = "VPC subnet used for deployment"
}

variable "image_version" {
  type    = string
  default = "2.1.27-ubuntu20"
}

variable "num_worker_nodes" {
  description = "Number of worker nodes in the Dataproc cluster"
  type        = number
  default     = 2
}

variable "worker_machine_type" {
  description = "Worker Machine type"
  type        = string
  default     = "e2-medium"
}

variable "master_machine_type" {
  description = "Master Machine type"
  type        = string
  default     = "e2-standard"
}