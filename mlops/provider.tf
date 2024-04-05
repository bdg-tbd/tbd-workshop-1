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
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      version = "~> 5.23.0"
    }
    google-beta = {
      version = "~> 5.23.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}