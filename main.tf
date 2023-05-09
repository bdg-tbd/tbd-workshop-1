module "gcr" {
  source       = "./modules/gcr"
  project_name = var.project_name
}

module "jupyter_docker_image" {
  depends_on         = [module.gcr]
  source             = "./modules/docker_image"
  registry_hostname  = module.gcr.registry_hostname
  registry_repo_name = coalesce(var.project_name)
}
module "vertex_ai_workbench" {
  depends_on                 = [module.jupyter_docker_image]
  source                     = "./modules/vertex-ai-workbench"
  project_name               = var.project_name
  region                     = var.region
  ai_notebook_instance_owner = var.ai_notebook_instance_owner
  ## To remove before workshop
  # FIXME:remove
  ai_notebook_image_repository = element(split(":", module.jupyter_docker_image.jupyter_image_name), 0)
  ai_notebook_image_tag        = element(split(":", module.jupyter_docker_image.jupyter_image_name), 1)
  ## To remove before workshop
}