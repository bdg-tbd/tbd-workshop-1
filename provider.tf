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
data "google_client_config" "provider" {}


data "google_container_cluster" "composer-gke-cluster" {
  name     = reverse(split("/", module.composer.gke_cluster))[0]
  location = var.region
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.composer-gke-cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.composer-gke-cluster.master_auth[0].cluster_ca_certificate,
  )
}

terraform {
  required_version = "~> 1.9.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.44.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.24.0"
    }
  }
}
