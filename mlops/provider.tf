provider "google" {
  project = var.project_name
  region  = var.region
}
provider "docker" {
  registry_auth {
    address     = try(module.gcp_registry.registry_hostname, "docker.io")
    config_file = pathexpand("~/.docker/config.json")
  }
}

terraform {
  required_version = "~> 1.11.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.44.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.44.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}