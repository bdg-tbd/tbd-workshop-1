
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
      metadata = {
        "PIP_PACKAGES" = "pandas<2 mlflow==2.3.1 google-cloud-storage==2.9.0"
      }
    }
    initialization_action {
      script      = "gs://goog-dataproc-initialization-actions-${var.region}/python/pip-install.sh"
      timeout_sec = "600"
    }

    master_config {
      num_instances = 1
      machine_type  = var.machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 100
      }
    }

    worker_config {
      num_instances = 2
      machine_type  = var.machine_type
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 100
      }

    }
  }
}