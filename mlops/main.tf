data "google_project" "project" {
  project_id = var.project_name
}

locals {
  mlflow_subnet_name = "mlflow-appengine"
}

module "gcp_registry" {
  project = var.project_name
  source  = "./mlflow/gcp/gcr"
}

module "mlflow_docker_image" {
  source             = "./mlflow/docker_image"
  registry_hostname  = module.gcp_registry.registry_hostname
  registry_repo_name = coalesce(var.project_name)
}

resource "google_project_service" "compute" {
  provider           = google
  service            = "compute.googleapis.com"
  disable_on_destroy = true
}

module "gcp_vpc" {
  #checkov:skip=CKV2_GCP_18: "Ensure GCP network defines a firewall and does not use the default firewall"
  depends_on   = [google_project_service.compute]
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0.0"
  project_id   = var.project_name
  network_name = "mlops"
  routing_mode = "GLOBAL"
  subnets = [
    {
      subnet_name   = local.mlflow_subnet_name
      subnet_ip     = "10.2.0.0/16"
      subnet_region = var.region
    }
  ]
}

module "gcp_mlflow_appengine" {
  depends_on              = [module.mlflow_docker_image]
  source                  = "./mlflow/gcp/app_engine"
  project_name            = var.project_name
  project_number          = data.google_project.project.number
  mlflow_docker_image_uri = module.mlflow_docker_image.mlflow_image_uri
  env                     = "dev"
  prefix                  = "tbd"
  region                  = var.region
  network                 = module.gcp_vpc.network
  subnet_name             = module.gcp_vpc.subnets["${var.region}/${local.mlflow_subnet_name}"].name
}