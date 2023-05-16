resource "google_project_service" "services" {
  project            = var.project_name
  for_each           = toset(["iap.googleapis.com", "appengineflex.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}



locals {
  app_version  = "v1"
  service_name = "mlflow"
  app_flex_sa  = "serviceAccount:service-${var.project_number}@gae-api-prod.google.com.iam.gserviceaccount.com"
  gae_sa       = [local.app_flex_sa, "serviceAccount:${var.project_name}@appspot.gserviceaccount.com"]

  gae_roles = [
    "roles/compute.networkUser",
    "roles/storage.objectViewer",
    "roles/logging.logWriter",
    "roles/cloudsql.client",
    "roles/monitoring.metricWriter",
    "roles/artifactregistry.reader"
  ]

  gae_sa_iam = distinct(flatten([
    for sa in local.gae_sa : [
      for role in local.gae_roles : {
        sa   = sa
        role = role
      }
    ]
  ]))

}

resource "google_project_iam_member" "mlflow_gae_iam" {
  depends_on = [google_project_service.services]
  for_each   = { for entry in local.gae_sa_iam : "${entry.sa}.${entry.role}" => entry }
  project    = var.project_name
  role       = each.value.role
  member     = each.value.sa
}



resource "google_app_engine_flexible_app_version" "mlflow_default_app" {
  project    = var.project_name
  service    = local.service_name
  version_id = local.app_version
  runtime    = "custom"

  deployment {
    container {
      image = var.mlflow_docker_image_uri
    }
  }
  network {
    name       = var.network.network_name
    subnetwork = var.subnet_name
  }

  liveness_check {
    path = "/"
  }

  readiness_check {
    path              = "/"
    app_start_timeout = "900s"
  }

  beta_settings = {
    cloud_sql_instances = google_sql_database_instance.mlflow_cloudsql_instance.connection_name
  }

  env_variables = {
    GCP_PROJECT                 = var.project_name
    DB_PASSWORD_SECRET_NAME     = google_secret_manager_secret.mlflow_db_password_secret.secret_id,
    DB_USERNAME                 = google_sql_user.mlflow_db_user.name
    DB_NAME                     = google_sql_database.mlflow_cloudsql_database.name
    DB_INSTANCE_CONNECTION_NAME = google_sql_database_instance.mlflow_cloudsql_instance.connection_name
    GCS_BACKEND                 = google_storage_bucket.mlflow_artifacts_bucket.url
  }

  automatic_scaling {
    cpu_utilization {
      target_utilization = 0.75
    }

    min_total_instances = 1
    max_total_instances = 4
  }

  resources {
    cpu       = 1
    memory_gb = 2
  }

  delete_service_on_destroy = true
  noop_on_destroy           = false

  timeouts {
    create = "20m"
  }

  depends_on = [
    google_secret_manager_secret_iam_member.mlflow_db_password_secret_iam,
    google_project_iam_member.mlflow_gae_iam
  ]

  inbound_services = []
}



resource "google_iap_web_type_app_engine_iam_binding" "binding" {
  depends_on = [google_project_service.services]
  project    = var.project_name
  app_id     = var.project_name
  role       = "roles/iap.httpsResourceAccessor"
  members = [
    "allAuthenticatedUsers",
    "serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",
  ]
}
