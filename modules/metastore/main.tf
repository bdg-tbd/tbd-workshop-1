resource "google_dataproc_metastore_service" "demo" {
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