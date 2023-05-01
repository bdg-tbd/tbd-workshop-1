output "workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.tbd-workload-identity-provider.name
}

output "service_account" {
  value = data.google_service_account.iac.email
}