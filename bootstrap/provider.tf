provider "google" {
  project = local.project
  region  = var.region
}
terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      version = "~> 5.23.0"
    }
  }
}