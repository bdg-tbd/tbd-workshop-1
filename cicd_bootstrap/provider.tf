provider "google" {
  project = var.project_name
  region  = var.region
}
terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      version = "~> 4.84.0"
    }
  }
}