variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "bucket_name" {
  type        = string
  description = "Bucket for storing data pipeline additional code"
}

variable "data_service_account" {
  type        = string
  description = "Service account with READER role to the bucket storing code"
}

variable "data_bucket_name" {
  type        = string
  description = "Bucket for storing and processing data"
}
