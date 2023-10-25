resource "google_project_service" "api-metastore" {
  project            = var.project_name
  for_each           = toset(["metastore.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}


resource "google_dataproc_metastore_service" "demo" {
  depends_on = [google_project_service.api-metastore]
  project    = var.project_name
  service_id = "metastore-srv"
  location   = var.region
  port       = 9080
  tier       = "DEVELOPER"
  network    = var.network

  hive_metastore_config {
    version = var.metastore_version
  }

  labels = {
    env = "demo"
  }
}