module "gcr" {
  source       = "./modules/gcr"
  project_name = var.project_name
}

module "vertex_ai_workbench" {
  depends_on                 = [module.gcr]
  source                     = "./modules/vertex-ai-workbench"
  project_name               = var.project_name
  region                     = var.region
  ai_notebook_instance_owner = var.ai_notebook_instance_owner
}