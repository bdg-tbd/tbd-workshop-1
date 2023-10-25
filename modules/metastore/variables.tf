variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "network" {
  type        = string
  description = "VPC to use for notebooks"
}

variable "metastore_version" {
  type        = string
  description = "Hive Metastore version"
  default     = "3.1.2"

}