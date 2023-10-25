output "metastore_name" {
  description = "Metastore server name"
  value       = google_dataproc_metastore_service.demo.service_id
}