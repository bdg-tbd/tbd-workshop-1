locals {
  project = lower("tbd-${var.tbd_semester}-${var.user_id}")
}

resource "google_project" "tbd_project" {
  name            = "TBD ${local.project} project"
  project_id      = local.project
  billing_account = var.billing_account
  lifecycle {
    prevent_destroy = true
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
  for_each = toset([
    "user:marek.wiewiorka@gmail.com",
    "user:tgambin@gmail.com"
  ])
  project = google_project.tbd_project.project_id
  role    = "roles/editor"
  member  = each.value
}


resource "google_project_iam_member" "tbd-editor-member" {
  project = google_project.tbd_project.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.tbd-terraform.email}"
}

resource "google_project_iam_member" "tbd-terraform-sa-member" {
  depends_on = [google_service_account.tbd-terraform]
  project    = google_project.tbd_project.project_id
  for_each   = toset(["roles/iam.securityAdmin", "roles/container.admin", "roles/storage.admin"])
  role       = each.value
  member     = "serviceAccount:${google_service_account.tbd-terraform.email}"
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
}
