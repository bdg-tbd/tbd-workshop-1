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
  default     = "e2-medium"
  description = "Machine type to use for both worker and master nodes"
}

variable "image_version" {
  type    = string
  default = "2.2.69-ubuntu22"
}

variable "preemptible_workers" {
  type        = number
  default     = 2
  description = "Number of preemptible/spot worker nodes in Dataproc cluster"
}
