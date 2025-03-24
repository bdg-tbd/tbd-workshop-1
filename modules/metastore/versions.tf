# Example configuration of terraform providers

terraform {
  required_version = "~> 1.11.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.44.0"
    }
  }
}