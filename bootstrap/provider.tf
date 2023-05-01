provider "google" {
  project = local.project
  region  = var.region
}
terraform {
  required_version = "~> 1.4.0"
  required_providers {
    google = {
      version = "~> 4.63.0"
    }
  }
}