locals {
  main_subnet_address     = "10.10.10.0/24"
  notebook_vpc_name       = "main-vpc"
  notebook_subnet_name    = "subnet-01"
  notebook_subnet_id      = "${var.region}/${local.notebook_subnet_name}"
  composer_subnet_address = "10.11.0.0/16"
  composer_work_namespace = "composer-user-workloads"
  code_bucket_name        = "${var.project_name}-code"
  data_bucket_name        = "${var.project_name}-data"
  spark_version           = "3.5.1"
  spark_driver_port       = 30000
  spark_blockmgr_port     = 30001
  dbt_version             = "1.8.7"
  dbt_spark_version       = "1.8.0"
  dbt_git_repo            = "https://github.com/mwiewior/tbd-tpc-di.git"
  dbt_git_repo_branch     = "main"

  # Airflow credentials — declared once, referenced everywhere
  airflow_db_user    = "postgres"
  airflow_db_name    = "airflow"
  airflow_db_host    = "airflow-pg"
  airflow_db_conn    = "postgresql+psycopg2://${local.airflow_db_user}:${var.airflow_db_password}@${local.airflow_db_host}:5432/${local.airflow_db_name}"
  airflow_admin_user = "admin"
  airflow_image      = "apache/airflow:2.10.5"
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

## Jupyter Docker image no longer needed - using Jupyter on Dataproc cluster instead
#module "jupyter_docker_image" {
#  depends_on         = [module.gcr]
#  source             = "./modules/jupyter_docker_image"
#  registry_hostname  = module.gcr.registry_hostname
#  registry_repo_name = coalesce(var.project_name)
#  project_name       = var.project_name
#  spark_version      = local.spark_version
#  dbt_version        = local.dbt_version
#  dbt_spark_version  = local.dbt_spark_version
#}

## Vertex AI Workbench replaced with Jupyter on Dataproc cluster
## See Dataproc module configuration for Jupyter optional component
#module "vertex_ai_workbench" {
#  depends_on   = [module.vpc]
#  source       = "./modules/vertex-ai-workbench"
#  project_name = var.project_name
#  region       = var.region
#  network      = module.vpc.network.network_id
#  subnet       = module.vpc.subnets[local.notebook_subnet_id].id
#
#  ai_notebook_instance_owner = var.ai_notebook_instance_owner
#  ## To remove before workshop
#  # FIXME:remove
#  ai_notebook_image_repository = element(split(":", module.jupyter_docker_image.jupyter_image_name), 0)
#  ai_notebook_image_tag        = element(split(":", module.jupyter_docker_image.jupyter_image_name), 1)
#  ## To remove before workshop
#}

#
module "dataproc" {
  depends_on    = [module.vpc]
  source        = "./modules/dataproc"
  project_name  = var.project_name
  region        = var.region
  subnet        = module.vpc.subnets[local.notebook_subnet_id].id
  machine_type  = "e2-standard-2"
  image_version = "2.2.69-ubuntu22"
}

## Uncomment for Dataproc batches (serverless)
#module "metastore" {
#  source = "./modules/metastore"
#  project_name   = var.project_name
#  region         = var.region
#  network        = module.vpc.network.network_id
#}

## Composer disabled — SSD quota on student billing accounts (250 GB) is too low
## for Composer 2 GKE Autopilot. Using lightweight GKE Standard + Helm Airflow instead.
#module "composer" {
#  depends_on     = [module.vpc]
#  source         = "./modules/composer"
#  project_name   = var.project_name
#  network        = module.vpc.network.network_name
#  subnet_address = local.composer_subnet_address
#  env_variables = {
#    "AIRFLOW_VAR_PROJECT_ID" : var.project_name,
#    "AIRFLOW_VAR_REGION_NAME" : var.region,
#    "AIRFLOW_VAR_BUCKET_NAME" : local.code_bucket_name
#    "AIRFLOW_VAR_PHS_CLUSTER" : module.dataproc.dataproc_cluster_name,
#    "AIRFLOW_VAR_WRK_NAMESPACE" : local.composer_work_namespace,
#    "AIRFLOW_VAR_DBT_GIT_REPO" : local.dbt_git_repo,
#    "AIRFLOW_VAR_DBT_GIT_REPO_BRANCH" : local.dbt_git_repo_branch
#  }
#}

## Airflow on GKE Standard (pd-standard disks, no SSD quota issues)
module "airflow" {
  depends_on   = [module.vpc]
  source       = "./modules/airflow"
  project_name = var.project_name
  region       = var.region
  network      = module.vpc.network.network_name
  subnet       = module.vpc.subnets[local.notebook_subnet_id].id
  machine_type = "e2-standard-2"
}

#module "dbt_docker_image" {
#  depends_on         = [module.airflow, module.gcr]
#  source             = "./modules/dbt_docker_image"
#  registry_hostname  = module.gcr.registry_hostname
#  registry_repo_name = coalesce(var.project_name)
#  project_name       = var.project_name
#  spark_version      = local.spark_version
#  dbt_version        = local.dbt_version
#  dbt_spark_version  = local.dbt_spark_version
#}

module "data-pipelines" {
  source               = "./modules/data-pipeline"
  project_name         = var.project_name
  region               = var.region
  bucket_name          = local.code_bucket_name
  data_service_account = module.dataproc.dataproc_service_account
  data_bucket_name     = local.data_bucket_name
}

resource "helm_release" "airflow" {
  depends_on = [kubernetes_job.airflow_db_migrate]
  name       = "airflow"
  repository = "https://airflow.apache.org"
  chart      = "airflow"
  version    = "1.16.0"
  namespace  = "airflow"

  create_namespace = false
  timeout          = 900
  wait             = true

  # Disable bundled bitnami PostgreSQL (image tags removed from DockerHub)
  # Use standalone postgres:16-alpine instead
  set {
    name  = "postgresql.enabled"
    value = "false"
  }
  set {
    name  = "data.metadataConnection.host"
    value = local.airflow_db_host
  }
  set {
    name  = "data.metadataConnection.db"
    value = local.airflow_db_name
  }
  set {
    name  = "data.metadataConnection.user"
    value = local.airflow_db_user
  }
  set_sensitive {
    name  = "data.metadataConnection.pass"
    value = var.airflow_db_password
  }

  # Shared PVC for DAG files — scheduler and webserver mount the same volume
  set {
    name  = "dags.persistence.enabled"
    value = "true"
  }
  set {
    name  = "dags.persistence.size"
    value = "1Gi"
  }

  # Use LocalExecutor — tasks run in scheduler process, no separate pods needed
  set {
    name  = "executor"
    value = "LocalExecutor"
  }
  set {
    name  = "webserver.service.type"
    value = "LoadBalancer"
  }
  # Reduce resource requests to fit on small nodes
  set {
    name  = "scheduler.resources.requests.cpu"
    value = "250m"
  }
  set {
    name  = "scheduler.resources.requests.memory"
    value = "512Mi"
  }
  set {
    name  = "webserver.resources.requests.cpu"
    value = "250m"
  }
  set {
    name  = "webserver.resources.requests.memory"
    value = "512Mi"
  }
  # Increase startup probe timeout — Gunicorn needs >60s on e2-standard-2
  set {
    name  = "webserver.startupProbe.failureThreshold"
    value = "12"
  }
  set {
    name  = "webserver.startupProbe.periodSeconds"
    value = "15"
  }
  set {
    name  = "triggerer.resources.requests.cpu"
    value = "250m"
  }
  set {
    name  = "triggerer.resources.requests.memory"
    value = "256Mi"
  }
  # Airflow variables for DAGs
  set {
    name  = "env[0].name"
    value = "AIRFLOW_VAR_PROJECT_ID"
  }
  set {
    name  = "env[0].value"
    value = var.project_name
  }
  set {
    name  = "env[1].name"
    value = "AIRFLOW_VAR_REGION_NAME"
  }
  set {
    name  = "env[1].value"
    value = var.region
  }
  set {
    name  = "env[2].name"
    value = "AIRFLOW_VAR_BUCKET_NAME"
  }
  set {
    name  = "env[2].value"
    value = local.code_bucket_name
  }
  set {
    name  = "env[3].name"
    value = "AIRFLOW_VAR_PHS_CLUSTER"
  }
  set {
    name  = "env[3].value"
    value = module.dataproc.dataproc_cluster_name
  }
}

# Standalone PostgreSQL for Airflow (bitnami images removed from DockerHub)
resource "kubernetes_namespace" "airflow" {
  depends_on = [module.airflow]
  metadata {
    name = "airflow"
  }
}

resource "kubernetes_stateful_set" "airflow_pg" {
  depends_on = [kubernetes_namespace.airflow]
  metadata {
    name      = "airflow-pg"
    namespace = "airflow"
  }
  spec {
    service_name = "airflow-pg"
    replicas     = 1
    selector {
      match_labels = {
        app = "airflow-pg"
      }
    }
    volume_claim_template {
      metadata {
        name = "pg-data"
      }
      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "5Gi"
          }
        }
      }
    }
    template {
      metadata {
        labels = {
          app = "airflow-pg"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:16-alpine"
          port {
            container_port = 5432
          }
          env {
            name  = "POSTGRES_DB"
            value = local.airflow_db_name
          }
          env {
            name  = "POSTGRES_USER"
            value = local.airflow_db_user
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.airflow_db_password
          }
          env {
            name  = "PGDATA"
            value = "/var/lib/postgresql/data/pgdata"
          }
          volume_mount {
            name       = "pg-data"
            mount_path = "/var/lib/postgresql/data"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "airflow_pg" {
  depends_on = [kubernetes_namespace.airflow]
  metadata {
    name      = "airflow-pg"
    namespace = "airflow"
  }
  spec {
    selector = {
      app = "airflow-pg"
    }
    port {
      port        = 5432
      target_port = 5432
    }
  }
}

# DB migration job — Helm hooks disabled because PostgreSQL is external
resource "kubernetes_job" "airflow_db_migrate" {
  depends_on = [kubernetes_stateful_set.airflow_pg, kubernetes_service.airflow_pg]
  metadata {
    name      = "airflow-db-migrate"
    namespace = "airflow"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "migrate"
          image   = local.airflow_image
          command = ["airflow", "db", "migrate"]
          env {
            name  = "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN"
            value = local.airflow_db_conn
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
  timeouts {
    create = "5m"
  }
}

# Create admin user after Helm installs Airflow
resource "kubernetes_job" "airflow_create_user" {
  depends_on = [helm_release.airflow]
  metadata {
    name      = "airflow-create-user"
    namespace = "airflow"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "create-user"
          image   = local.airflow_image
          command = ["airflow", "users", "create", "--username", local.airflow_admin_user, "--password", var.airflow_admin_password, "--firstname", "Admin", "--lastname", "User", "--role", "Admin", "--email", "admin@example.com"]
          env {
            name  = "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN"
            value = local.airflow_db_conn
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
  timeouts {
    create = "5m"
  }
}

# Create google_cloud_default connection for DataprocSubmitJobOperator
resource "kubernetes_job" "airflow_gcp_connection" {
  depends_on = [helm_release.airflow]
  metadata {
    name      = "airflow-gcp-connection"
    namespace = "airflow"
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name    = "create-connection"
          image   = local.airflow_image
          command = ["airflow", "connections", "add", "google_cloud_default", "--conn-type", "google_cloud_platform", "--conn-extra", "{\"project\": \"${var.project_name}\"}"]
          env {
            name  = "AIRFLOW__DATABASE__SQL_ALCHEMY_CONN"
            value = local.airflow_db_conn
          }
        }
        restart_policy = "Never"
      }
    }
    backoff_limit = 2
  }
  wait_for_completion = true
  timeouts {
    create = "5m"
  }
}

resource "google_compute_firewall" "allow-internal-tcp" {
  name    = "allow-internal-tcp"
  project = var.project_name
  network = module.vpc.network.network_name
  allow {
    protocol = "tcp"
  }
  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "allow-internal-udp" {
  name    = "allow-internal-udp"
  project = var.project_name
  network = module.vpc.network.network_name
  allow {
    protocol = "udp"
  }
  source_ranges = ["10.0.0.0/8"]
}

resource "google_compute_firewall" "allow-internal-icmp" {
  name    = "allow-internal-icmp"
  project = var.project_name
  network = module.vpc.network.network_name
  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.0.0.0/8"]
}