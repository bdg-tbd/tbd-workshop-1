# Example configuration of terraform providers

terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.23.0"
    }
  }
}