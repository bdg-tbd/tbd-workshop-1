output "gcs_bucket" {
  description = "GCS bucket for storing Apache Airflow DAGs"
  value       = module.composer.gcs_bucket
}

output "data_service_account" {
  description = "Apache Airflow service account"
  value       = google_service_account.tbd-composer-sa.email
}

output "gke_cluster" {
  description = "Composer underlying GKE cluster"
  value       = module.composer.gke_cluster
}