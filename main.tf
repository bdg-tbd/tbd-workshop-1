module "vertex_ai_workbench" {
  source       = "./modules/vertex-ai-workbench"
  project_name = var.project_name
  region       = var.region
}