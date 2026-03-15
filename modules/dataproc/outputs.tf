output "dataproc_cluster_name" {
  description = "Dataproc cluster name"
  value       = google_dataproc_cluster.tbd-dataproc-cluster.name
}

output "dataproc_service_account" {
  description = "Dataproc service account email"
  value       = google_service_account.dataproc_sa.email
}