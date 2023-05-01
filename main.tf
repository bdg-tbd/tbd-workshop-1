resource "google_project_service" "notebooks" {
  provider           = google
  service            = "notebooks.googleapis.com"
  disable_on_destroy = true
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = var.project_name
  network_name = "main-vpc"
  routing_mode = "GLOBAL"
}