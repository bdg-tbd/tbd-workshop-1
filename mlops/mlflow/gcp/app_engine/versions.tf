terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.23.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.2"
    }
  }
}