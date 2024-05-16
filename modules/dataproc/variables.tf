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

variable "master_machine_type" {
  type        = string
  default     = "e2-medium"
  description = "Machine type to use for master nodes"
}

variable "worker_machine_type" {
  type        = string
  default     = "e2-medium"
  description = "Machine type to use for worker nodes"
}

variable "image_version" {
  type    = string
  default = "2.1.27-ubuntu20"
}