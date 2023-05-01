variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "iac_service_account" {
  type        = string
  description = "Service account to be used with CI/CD workload identity"
}

variable "github_repo" {
  type        = string
  description = "Github repository"
}

variable "github_org" {
  type        = string
  description = "Github organisation"
}