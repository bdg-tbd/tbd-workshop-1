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

variable "machine_type" {
  type        = string
  description = "Machine type to use for both worker and master nodes"
}

variable "image_version" {
  type    = string
  default = "2.1.27-ubuntu20"
}

variable "number_of_worker_machines" {
  type        = number
  description = "Number of worker instances in dataproc module"
}

variable "number_of_preemptible_machines" {
  type        = number
  description = "Number of preemptible instances in dataproc module"
}
