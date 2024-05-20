locals {
  composer_account_id = "${var.project_name}-data"
}

resource "google_service_account" "tbd-composer-sa" {
  project    = var.project_name
  account_id = local.composer_account_id
}

resource "google_project_iam_member" "composer-member" {
  #checkov:skip=CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
  #checkov:skip=CKV_GCP_117: "Ensure basic roles are not used at project level."
  # This is only used for workshops!!!
  project = var.project_name
  role    = "roles/composer.worker"
  member  = "serviceAccount:${google_service_account.tbd-composer-sa.email}"
}

resource "google_project_service" "api" {
  project            = var.project_name
  for_each           = toset(["composer.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}

resource "google_compute_subnetwork" "composer-subnet" {
  name                       = var.subnet_name
  ip_cidr_range              = var.subnet_address
  region                     = var.region
  network                    = var.network
  private_ipv6_google_access = "DISABLE_GOOGLE_ACCESS"
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}


module "composer" {
  depends_on = [google_project_service.api, google_project_iam_member.composer-member]
  source     = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version    = "~> 5.0.0"

  project_id                = var.project_name
  region                    = var.region
  composer_env_name         = var.env_name
  network                   = var.network
  subnetwork                = google_compute_subnetwork.composer-subnet.name
  enable_private_endpoint   = false
  environment_size          = var.env_size
  image_version             = var.image_version
  grant_sa_agent_permission = true
  composer_service_account  = google_service_account.tbd-composer-sa.email
  env_variables             = var.env_variables
  scheduler = {
    cpu        = 0.5
    memory_gb  = 1.875
    storage_gb = 1
    count      = 1
  }
  web_server = {
    cpu        = 0.5
    memory_gb  = 1.875
    storage_gb = 1
  }
  worker = {
    cpu        = 0.5
    memory_gb  = 1.875
    storage_gb = 1
    min_count  = 1
    max_count  = 3
  }
}



resource "google_project_iam_member" "dataproc-editor-iam" {
  project = var.project_name
  role    = "roles/dataproc.editor"
  member  = "serviceAccount:${google_service_account.tbd-composer-sa.email}"
}

resource "google_project_iam_member" "dataproc-sa-user-iam" {
  project = var.project_name
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.tbd-composer-sa.email}"
}


