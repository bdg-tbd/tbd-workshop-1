data "google_service_account" "iac" {
  account_id = var.iac_service_account
}

resource "google_iam_workload_identity_pool" "tbd-workload-identity-pool" {
  workload_identity_pool_id = "github-actions-pool"
}

resource "google_iam_workload_identity_pool_provider" "tbd-workload-identity-provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.tbd-workload-identity-pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions-provider"
  display_name                       = "GitHub provider"
  description                        = "GitHub identity pool provider for CI/CD purposes"
  attribute_mapping = {
    "google.subject" : "assertion.sub"
    "attribute.repository" : "assertion.repository"
    "attribute.owner" = "assertion.repository_owner"
    "attribute.refs"  = "assertion.ref"
  }
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account_iam_member" "tbd-sa-workload-identity-iam" {
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = data.google_service_account.iac.name
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tbd-workload-identity-pool.name}/attribute.repository/${var.github_org}/${var.github_repo}"
}