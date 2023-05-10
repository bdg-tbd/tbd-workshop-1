
resource "google_project_service" "dataproc" {
  provider           = google
  service            = "dataproc.googleapis.com"
  disable_on_destroy = true
}
resource "google_dataproc_cluster" "tbd-dataproc-cluster" {
  #checkov:skip=CKV_GCP_91: "Ensure Dataproc cluster is encrypted with Customer Supplied Encryption Keys (CSEK)"
  depends_on = [google_project_service.dataproc]
  name       = "tbd-cluster"
  project    = var.project_name
  region     = var.region
  cluster_config {
    software_config {
      image_version = var.image_version
    }
    gce_cluster_config {
      subnetwork       = var.subnet
      internal_ip_only = true
    }
    master_config {
      num_instances = 1
      machine_type  = var.machine_type
    }

    worker_config {
      num_instances = 2
      machine_type  = var.machine_type

    }
  }
}