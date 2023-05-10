locals {
  notebook_vpc_name    = "main-vpc"
  notebook_subnet_name = "subnet-01"
  notebook_subnet_id   = "${var.region}/${local.notebook_subnet_name}"
}

module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name
  region       = var.region
  network_name = local.notebook_vpc_name
  subnet_name  = local.notebook_subnet_name
}


module "gcr" {
  source       = "./modules/gcr"
  project_name = var.project_name
}

module "jupyter_docker_image" {
  depends_on         = [module.gcr]
  source             = "./modules/docker_image"
  registry_hostname  = module.gcr.registry_hostname
  registry_repo_name = coalesce(var.project_name)
  project_name       = var.project_name
}

module "vertex_ai_workbench" {
  depends_on   = [module.jupyter_docker_image, module.vpc]
  source       = "./modules/vertex-ai-workbench"
  project_name = var.project_name
  region       = var.region
  network      = module.vpc.network.network_id
  subnet       = module.vpc.subnets[local.notebook_subnet_id].id

  ai_notebook_instance_owner = var.ai_notebook_instance_owner
  ## To remove before workshop
  # FIXME:remove
  ai_notebook_image_repository = element(split(":", module.jupyter_docker_image.jupyter_image_name), 0)
  ai_notebook_image_tag        = element(split(":", module.jupyter_docker_image.jupyter_image_name), 1)
  ## To remove before workshop
}

#
module "dataproc" {
  depends_on   = [module.vpc]
  source       = "./modules/dataproc"
  project_name = var.project_name
  region       = var.region
  subnet       = module.vpc.subnets[local.notebook_subnet_id].id
}