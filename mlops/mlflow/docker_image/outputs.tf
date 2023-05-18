output "mlflow_image_uri" {
  value       = docker_image.mlflow.repo_digest
  description = "MLflow imager URI"
}