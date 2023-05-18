locals {
  project = lower("tbd-${var.tbd_semester}-${var.user_id}")
}

resource "google_project" "tbd_project" {
  name            = "TBD ${local.project} project"
  project_id      = local.project
  billing_account = var.billing_account
  ## change it to break the checkov during the labs
  auto_create_network = false
  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_iam_audit_config" "tbd_project_audit" {
  project = google_project.tbd_project.id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}


resource "google_project_service" "tbd-service" {
  project                    = google_project.tbd_project.project_id
  disable_dependent_services = true
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "serviceusage.googleapis.com",
  "sts.googleapis.com"])
  service = each.value
}

resource "google_service_account" "tbd-terraform" {
  project    = google_project.tbd_project.project_id
  account_id = "${local.project}-lab"
}


resource "google_project_iam_member" "tbd-editor-supervisors" {
  #checkov:skip=CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
  #checkov:skip=CKV_GCP_117: "Ensure basic roles are not used at project level."
  # This is only used for workshops!!!
  for_each = toset([
    "user:marek.wiewiorka@gmail.com",
    "user:tgambin@gmail.com",
    "user:sitekwb@gmail.com"
  ])
  project = google_project.tbd_project.project_id
  role    = "roles/editor"
  member  = each.value
}


resource "google_project_iam_member" "tbd-editor-member" {
  #checkov:skip=CKV_GCP_49: "Ensure no roles that enable to impersonate and manage all service accounts are used at a project level"
  #checkov:skip=CKV_GCP_117: "Ensure basic roles are not used at project level."
  # This is only used for workshops!!!
  project = google_project.tbd_project.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.tbd-terraform.email}"
}



resource "google_storage_bucket" "tbd-state-bucket" {
  project                     = google_project.tbd_project.project_id
  name                        = "${local.project}-state"
  location                    = var.region
  uniform_bucket_level_access = false #tfsec:ignore:google-storage-enable-ubla
  force_destroy               = true
  lifecycle {
    prevent_destroy = true
  }

  #checkov:skip=CKV_GCP_62: "Bucket should log access"
  #checkov:skip=CKV_GCP_29: "Ensure that Cloud Storage buckets have uniform bucket-level access enabled"
  #checkov:skip=CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
  public_access_prevention = "enforced"
}
