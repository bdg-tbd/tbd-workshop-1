output "mlflow_artifacts_bucket_name" {
  value = google_storage_bucket.mlflow_artifacts_bucket.name
}

output "mlflow_appengine_url" {
  value = "https://${local.app_version}-dot-${local.service_name}-dot-${var.project_name}.appspot.com"
}