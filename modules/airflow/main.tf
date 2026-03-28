terraform {
  required_version = "~> 1.11.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.44.0"
    }
  }
}

resource "google_project_service" "container" {
  project            = var.project_name
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_service_account" "airflow_sa" {
  project    = var.project_name
  account_id = "${var.project_name}-airflow-sa"
}

resource "google_project_iam_member" "airflow_dataproc_editor" {
  project = var.project_name
  role    = "roles/dataproc.editor"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

resource "google_project_iam_member" "airflow_sa_user" {
  project = var.project_name
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

resource "google_project_iam_member" "airflow_storage" {
  project = var.project_name
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.airflow_sa.email}"
}

resource "google_container_cluster" "airflow" {
  #checkov:skip=CKV_GCP_91: "Workshop cluster — CSEK not needed"
  #checkov:skip=CKV_GCP_24: "Workshop cluster — PodSecurityPolicy not needed"
  #checkov:skip=CKV_GCP_25: "Workshop cluster — private cluster not required"
  #checkov:skip=CKV_GCP_18: "Workshop cluster — master auth networks not required"
  #checkov:skip=CKV_GCP_12: "Workshop cluster — network policy not required"
  #checkov:skip=CKV_GCP_23: "Workshop cluster — alias IPs not required"
  #checkov:skip=CKV_GCP_61: "Workshop cluster — VPC flow logs not required"
  #checkov:skip=CKV_GCP_70: "Workshop cluster — release channel not required"
  #checkov:skip=CKV_GCP_20: "Workshop cluster — master authorized networks not required"
  #checkov:skip=CKV_GCP_21: "Workshop cluster — labels not required"
  #checkov:skip=CKV_GCP_13: "Workshop cluster — client certificate auth not required"
  #checkov:skip=CKV_GCP_65: "Workshop cluster — Google Groups RBAC not required"
  #checkov:skip=CKV_GCP_64: "Workshop cluster — private nodes not required"
  #checkov:skip=CKV_GCP_66: "Workshop cluster — binary authorization not required"
  #checkov:skip=CKV_GCP_69: "Workshop cluster — GKE metadata server not required"
  depends_on = [google_project_service.container]

  name     = "airflow-cluster"
  project  = var.project_name
  location = "${var.region}-b"

  # Use Standard mode (not Autopilot) to avoid SSD quota issues
  initial_node_count       = 1
  remove_default_node_pool = true

  network    = var.network
  subnetwork = var.subnet

  deletion_protection = false
}

resource "google_container_node_pool" "airflow_nodes" {
  #checkov:skip=CKV_GCP_10: "Workshop node pool — auto-upgrade not required"
  #checkov:skip=CKV_GCP_68: "Workshop node pool — secure boot not required"
  #checkov:skip=CKV_GCP_9: "Workshop node pool — auto-repair not required"
  #checkov:skip=CKV_GCP_69: "Workshop node pool — GKE metadata server not required"
  name     = "airflow-pool"
  project  = var.project_name
  location = "${var.region}-b"
  cluster  = google_container_cluster.airflow.name

  node_count = 2

  lifecycle {
    ignore_changes = [node_config]
  }

  node_config {
    machine_type    = var.machine_type
    service_account = google_service_account.airflow_sa.email
    oauth_scopes    = ["https://www.googleapis.com/auth/cloud-platform"]

    disk_type    = "pd-standard"
    disk_size_gb = 50
  }
}
