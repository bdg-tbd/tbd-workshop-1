output "dbt_image_uri" {
  value       = docker_image.dbt.repo_digest
  description = "Jupyterlab image URI"
}

output "dbt_image_name" {
  value = docker_image.dbt.name
}
