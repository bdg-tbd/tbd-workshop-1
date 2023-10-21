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

module "composer" {
  depends_on = [google_project_service.api, google_project_iam_member.composer-member]
  source     = "terraform-google-modules/composer/google//modules/create_environment_v2"
  version    = "~> 3.4.0"

  project_id                = var.project_name
  region                    = var.region
  composer_env_name         = var.env_name
  network                   = var.network
  subnetwork                = var.subnet
  enable_private_endpoint   = false
  environment_size          = var.env_size
  image_version             = var.image_version
  grant_sa_agent_permission = true
  composer_service_account  = google_service_account.tbd-composer-sa.email
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

