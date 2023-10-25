locals {
  main_subnet_address     = "10.10.10.0/24"
  notebook_vpc_name       = "main-vpc"
  notebook_subnet_name    = "subnet-01"
  notebook_subnet_id      = "${var.region}/${local.notebook_subnet_name}"
  composer_subnet_address = "10.11.0.0/16"
  code_bucket_name        = "${var.project_name}-code"
  data_bucket_name        = "${var.project_name}-data"
}

module "vpc" {
  source         = "./modules/vpc"
  project_name   = var.project_name
  region         = var.region
  network_name   = local.notebook_vpc_name
  subnet_name    = local.notebook_subnet_name
  subnet_address = local.main_subnet_address
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
  machine_type = "e2-standard-2"
}

## Uncomment for Dataproc batches (serverless)
#module "metastore" {
#  source = "./modules/metastore"
#  project_name   = var.project_name
#  region         = var.region
#  network        = module.vpc.network.network_id
#}

module "composer" {
  depends_on     = [module.vpc]
  source         = "./modules/composer"
  project_name   = var.project_name
  network        = module.vpc.network.network_name
  subnet_address = local.composer_subnet_address
  env_variables = {
    "AIRFLOW_VAR_PROJECT_ID" : var.project_name,
    "AIRFLOW_VAR_REGION_NAME" : var.region,
    "AIRFLOW_VAR_BUCKET_NAME" : local.code_bucket_name
    "AIRFLOW_VAR_PHS_CLUSTER" : module.dataproc.dataproc_cluster_name,
  }
}

module "data-pipelines" {
  source               = "./modules/data-pipeline"
  project_name         = var.project_name
  region               = var.region
  bucket_name          = local.code_bucket_name
  data_service_account = module.composer.data_service_account
  dag_bucket_name      = module.composer.gcs_bucket
  data_bucket_name     = local.data_bucket_name
}

