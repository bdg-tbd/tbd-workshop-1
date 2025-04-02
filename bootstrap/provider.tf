provider "google" {
  project = local.project
  region  = var.region
}

provider "google" {
  alias                 = "billing"
  project               = local.project
  region                = var.region
  user_project_override = true
}
terraform {
  required_version = "~> 1.11.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.26.0"
    }
  }
}