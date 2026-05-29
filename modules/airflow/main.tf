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
  #checkov:skip=CKV_GCP_64: "Workshop cluster - Private nodes not required"
  #checkov:skip=CKV_GCP_13: "Workshop cluster - Client cert auth disabled check not required"
  #checkov:skip=CKV_GCP_69: "Workshop cluster - GKE Metadata Server not required"
  #checkov:skip=CKV_GCP_65: "Workshop cluster - Google Groups RBAC not required"
  #checkov:skip=CKV_GCP_66: "Workshop cluster - Binary Authorization not required"
  #checkov:skip=CKV_GCP_70: "Workshop cluster - Release channel not required"
  #checkov:skip=CKV_GCP_20: "Workshop cluster - Master authorized networks not required"
  #checkov:skip=CKV_GCP_61: "Workshop cluster - VPC Flow Logs not required"
  #checkov:skip=CKV_GCP_21: "Workshop cluster - Resource labels not required"

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

  #checkov:skip=CKV_GCP_69: "Workshop pool - GKE Metadata Server not required"
  #checkov:skip=CKV_GCP_10: "Workshop pool - Auto node upgrade not required"
  #checkov:skip=CKV_GCP_68: "Workshop pool - Secure boot not required"
  #checkov:skip=CKV_GCP_9:  "Workshop pool - Auto node repair not required"

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
