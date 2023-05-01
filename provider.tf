provider "google" {
  project = var.project_name
  region  = var.region
}
terraform {
  required_providers {
    google = {
      version = "~> 4.63.0"
    }
  }
}