output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.airflow.name
}

output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.airflow.endpoint
}

output "cluster_ca_certificate" {
  description = "GKE cluster CA certificate"
  value       = google_container_cluster.airflow.master_auth[0].cluster_ca_certificate
}

output "cluster_location" {
  description = "GKE cluster location (zone)"
  value       = google_container_cluster.airflow.location
}

output "service_account" {
  description = "Airflow service account email"
  value       = google_service_account.airflow_sa.email
}
