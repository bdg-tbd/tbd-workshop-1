locals {
  registry_hostname = "${lower(var.location)}.gcr.io"
}


resource "google_project_service" "api" {
  project            = var.project_name
  for_each           = toset(["containerregistry.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}

resource "google_container_registry" "registry" {
  depends_on = [google_project_service.api]
  project    = var.project_name
  location   = var.location
}