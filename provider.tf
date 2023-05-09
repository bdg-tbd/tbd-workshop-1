provider "google" {
  project = var.project_name
  region  = var.region
}
provider "docker" {
  registry_auth {
    address     = try(module.gcr.registry_hostname, "docker.io")
    config_file = pathexpand("~/.docker/config.json")
  }
}

terraform {
  required_version = "~> 1.4.0"
  required_providers {
    google = {
      version = "~> 4.63.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}