provider "google" {
  project = local.project
  region  = var.region
}
terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.23.0"
    }
  }
}