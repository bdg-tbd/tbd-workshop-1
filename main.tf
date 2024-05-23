locals {
  main_subnet_address     = "10.10.10.0/24"
  notebook_vpc_name       = "main-vpc"
  notebook_subnet_name    = "subnet-01"
  notebook_subnet_id      = "${var.region}/${local.notebook_subnet_name}"
  composer_subnet_address = "10.11.0.0/16"
  composer_work_namespace = "composer-user-workloads"
  code_bucket_name        = "${var.project_name}-code"
  data_bucket_name        = "${var.project_name}-data"
  spark_version           = "3.3.2"
  spark_driver_port       = 30000
  spark_blockmgr_port     = 30001
  dbt_version             = "1.7.13"
  dbt_spark_version       = "1.7.1"
  dbt_git_repo            = "https://github.com/mwiewior/tbd-tpc-di.git"
  dbt_git_repo_branch     = "main"
  mlflow_version          = "2.12.2"
  kedro_version           = "0.19.5"
  vs_code_version         = "4.23.1"
  jupyterlab_version      = "4.1.6"
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
  source             = "./modules/jupyter_docker_image"
  registry_hostname  = module.gcr.registry_hostname
  registry_repo_name = coalesce(var.project_name)
  project_name       = var.project_name
  spark_version      = local.spark_version
  dbt_version        = local.dbt_version
  dbt_spark_version  = local.dbt_spark_version
  jupyterlab_version = local.jupyterlab_version
}

module "jupyter_mlops_docker_image" {
  depends_on         = [module.gcr]
  source             = "./modules/jupyter_mlops_docker_image"
  registry_hostname  = module.gcr.registry_hostname
  registry_repo_name = coalesce(var.project_name)
  project_name       = var.project_name
  spark_version      = local.spark_version
  dbt_version        = local.dbt_version
  dbt_spark_version  = local.dbt_spark_version
  kedro_version      = local.kedro_version
  mlflow_version     = local.mlflow_version
  vs_code_version    = local.vs_code_version
  jupyterlab_version = local.jupyterlab_version
}

module "vertex_ai_workbench" {
  depends_on   = [module.jupyter_docker_image, module.jupyter_mlops_docker_image, module.vpc]
  source       = "./modules/vertex-ai-workbench"
  project_name = var.project_name
  region       = var.region
  network      = module.vpc.network.network_id
  subnet       = module.vpc.subnets[local.notebook_subnet_id].id

  ai_notebook_instance_owner = var.ai_notebook_instance_owner

  ai_notebook_image_repository = var.jupyter_image_flavour == "dataops" ? element(split(":", module.jupyter_docker_image.jupyter_image_name), 0) : element(split(":", module.jupyter_mlops_docker_image.jupyter_image_name), 0)
  ai_notebook_image_tag        = var.jupyter_image_flavour == "dataops" ? element(split(":", module.jupyter_docker_image.jupyter_image_name), 1) : element(split(":", module.jupyter_mlops_docker_image.jupyter_image_name), 1)

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
  count          = var.enable_composer ? 1 : 0
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
    "AIRFLOW_VAR_WRK_NAMESPACE" : local.composer_work_namespace,
    "AIRFLOW_VAR_DBT_GIT_REPO" : local.dbt_git_repo,
    "AIRFLOW_VAR_DBT_GIT_REPO_BRANCH" : local.dbt_git_repo_branch
  }
}

module "dbt_docker_image" {
  count              = var.enable_composer ? 1 : 0
  depends_on         = [module.composer[0], module.gcr]
  source             = "./modules/dbt_docker_image"
  registry_hostname  = module.gcr.registry_hostname
  registry_repo_name = coalesce(var.project_name)
  project_name       = var.project_name
  spark_version      = local.spark_version
  dbt_version        = local.dbt_version
  dbt_spark_version  = local.dbt_spark_version
}

module "data-pipelines" {
  count                = var.enable_composer ? 1 : 0
  source               = "./modules/data-pipeline"
  project_name         = var.project_name
  region               = var.region
  bucket_name          = local.code_bucket_name
  data_service_account = module.composer[0].data_service_account
  dag_bucket_name      = module.composer[0].gcs_bucket
  data_bucket_name     = local.data_bucket_name
}




resource "kubernetes_service" "dbt-task-service" {
  count = var.enable_composer ? 1 : 0
  metadata {
    name      = "dbt-task-service"
    namespace = local.composer_work_namespace
    labels = {
      app = "dbt-app"
    }
  }

  spec {
    type = "NodePort"
    selector = {
      app = "dbt-app"
    }
    port {
      name        = "spark-driver"
      protocol    = "TCP"
      port        = local.spark_driver_port
      target_port = local.spark_driver_port
      node_port   = local.spark_driver_port

    }
    port {
      name        = "spark-block-mgr"
      protocol    = "TCP"
      port        = local.spark_blockmgr_port
      target_port = local.spark_blockmgr_port
      node_port   = local.spark_blockmgr_port
    }

  }
}

resource "google_compute_firewall" "allow-all-internal" {
  name    = "allow-all-internal"
  project = var.project_name
  network = module.vpc.network.network_name
  allow {
    protocol = "all"
  }
  source_ranges = ["10.0.0.0/8"]
}