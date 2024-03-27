# Example configuration of terraform providers

terraform {
  required_version = "~> 1.7.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.3.0"
    }
  }
}
