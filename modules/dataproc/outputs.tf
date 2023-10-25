output "dataproc_cluster_name" {
  description = "Dataproc cluster name"
  value       = google_dataproc_cluster.tbd-dataproc-cluster.name
}