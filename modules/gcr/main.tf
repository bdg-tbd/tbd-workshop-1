locals {
  registry_hostname = "${lower(var.location)}.gcr.io"
}


resource "google_project_service" "api" {
  project            = var.project_name
  for_each           = toset(["artifactregistry.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "registry" {
  #checkov:skip=CKV_GCP_84: "Ensure Artifact Registry Repositories are encrypted with Customer Supplied Encryption Keys (CSEK)"
  depends_on    = [google_project_service.api]
  location      = "europe"
  repository_id = local.registry_hostname
  description   = "TBD Docker repository"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }
}