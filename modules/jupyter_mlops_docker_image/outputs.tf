output "jupyter_image_uri" {
  value       = docker_image.jupyter-mlops.repo_digest
  description = "Jupyterlab image URI"
}

output "jupyter_image_name" {
  value = docker_image.jupyter-mlops.name
}
