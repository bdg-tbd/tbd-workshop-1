# Example configuration of terraform providers

terraform {
  required_version = "~> 1.5.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}