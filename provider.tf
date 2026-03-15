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

provider "kubernetes" {
  host                   = "https://${module.airflow.cluster_endpoint}"
  token                  = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(module.airflow.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.airflow.cluster_endpoint}"
    token                  = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(module.airflow.cluster_ca_certificate)
  }
}

terraform {
  required_version = "~> 1.11.0"
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
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}