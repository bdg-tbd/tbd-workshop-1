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

variable "machine_type_master" {
  type        = string
  default     = "e2-medium"
  description = "Machine type used for master nodes"
}

variable "machine_type_worker" {
  type        = string
  default     = "e2-medium"
  description = "Machine type used for worker nodes"
}

variable "image_version" {
  type    = string
  default = "2.1.27-ubuntu20"
}

variable "worker_nodes_number" {
  type        = number
  default     = 2
  description = "Number of worker nodes"
}
