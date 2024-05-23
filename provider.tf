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
  count    = var.enable_composer ? 1 : 0
  name     = reverse(split("/", module.composer[0].gke_cluster))[0]
  location = var.region
}

provider "kubernetes" {
  host  = var.enable_composer ? "https://${data.google_container_cluster.composer-gke-cluster[0].endpoint}" : ""
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    var.enable_composer ? data.google_container_cluster.composer-gke-cluster[0].master_auth[0].cluster_ca_certificate : "",
  )
}

terraform {
  required_version = "~> 1.5.0"
  required_providers {
    google = {
      version = "~> 5.23.0"
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