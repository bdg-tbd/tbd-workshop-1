
resource "google_project_service" "dataproc" {
  provider           = google
  service            = "dataproc.googleapis.com"
  disable_on_destroy = true
}

resource "google_service_account" "dataproc_sa" {
  account_id   = "${var.project_name}-dataproc-sa"
  display_name = "Dataproc Service Account"
  project      = var.project_name
}

resource "google_project_iam_member" "dataproc_worker" {
  project = var.project_name
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.dataproc_sa.email}"
}

resource "google_project_iam_member" "dataproc_bigquery_data_editor" {
  project = var.project_name
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.dataproc_sa.email}"
}

resource "google_project_iam_member" "dataproc_bigquery_user" {
  project = var.project_name
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.dataproc_sa.email}"
}

resource "google_storage_bucket" "dataproc_staging" {
  name                        = "${var.project_name}-dataproc-staging"
  location                    = var.region
  project                     = var.project_name
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "dataproc_temp" {
  name                        = "${var.project_name}-dataproc-temp"
  location                    = var.region
  project                     = var.project_name
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }
}

resource "google_storage_bucket_iam_member" "staging_bucket_iam" {
  bucket = google_storage_bucket.dataproc_staging.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataproc_sa.email}"
}

resource "google_storage_bucket_iam_member" "temp_bucket_iam" {
  bucket = google_storage_bucket.dataproc_temp.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.dataproc_sa.email}"
}

resource "google_dataproc_cluster" "tbd-dataproc-cluster" {
  #checkov:skip=CKV_GCP_91: "Ensure Dataproc cluster is encrypted with Customer Supplied Encryption Keys (CSEK)"
  depends_on = [
    google_project_service.dataproc,
    google_service_account.dataproc_sa,
    google_project_iam_member.dataproc_worker,
    google_project_iam_member.dataproc_bigquery_data_editor,
    google_project_iam_member.dataproc_bigquery_user,
    google_storage_bucket_iam_member.staging_bucket_iam,
    google_storage_bucket_iam_member.temp_bucket_iam
  ]
  name    = "tbd-cluster"
  project = var.project_name
  region  = var.region

  lifecycle {
    ignore_changes = [
      cluster_config[0].gce_cluster_config[0].service_account_scopes,
    ]
  }

  cluster_config {
    staging_bucket = google_storage_bucket.dataproc_staging.name
    temp_bucket    = google_storage_bucket.dataproc_temp.name

    endpoint_config {
      enable_http_port_access = true
    }

    software_config {
      image_version       = var.image_version
      optional_components = ["JUPYTER"]
    }

    gce_cluster_config {
      subnetwork             = var.subnet
      internal_ip_only       = true
      service_account        = google_service_account.dataproc_sa.email
      service_account_scopes = ["cloud-platform"]
      metadata = {
        "PIP_PACKAGES" = "pandas<2 mlflow==2.3.1 google-cloud-storage==2.9.0 jupyterlab==3.6.3 dbt-core==1.8.7 dbt-spark==1.8.0"
        "vmDnsSetting" = "GlobalDefault"
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

    # preemptible / spot workers
    secondary_worker_config {
      num_instances  = 4
      machine_type   = var.machine_type
      preemptibility = "PREEMPTIBLE"

      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 100
      }
    }
  }
}
