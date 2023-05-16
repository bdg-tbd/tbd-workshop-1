

resource "google_project_service" "service_networking" {
  project            = var.project_name
  for_each           = toset(["servicenetworking.googleapis.com", "sqladmin.googleapis.com"])
  service            = each.value
  disable_on_destroy = false
}


resource "random_password" "mlflow_db_password" {
  length  = 32
  special = false
}

resource "random_id" "db_name_suffix" {
  byte_length = 3
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google

  name          = "private-mlops-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network.network_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  depends_on = [google_project_service.service_networking]
  provider   = google-beta

  network                 = var.network.network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}



resource "google_sql_database_instance" "mlflow_cloudsql_instance" {
  #checkov:skip=CKV_GCP_6: "Ensure all Cloud SQL database instance requires all incoming connections to use SSL"
  depends_on = [google_service_networking_connection.private_vpc_connection]
  project    = var.project_name

  name             = "${var.prefix}-mlflow-${var.env}-${var.region}-${random_id.db_name_suffix.hex}"
  database_version = "MYSQL_8_0"
  region           = var.region

  settings {
    tier              = var.machine_type
    availability_type = var.availability_type

    disk_size       = 10
    disk_autoresize = true

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.network.network_id
      enable_private_path_for_google_cloud_services = true

    }

    maintenance_window {
      day          = 7
      hour         = 3
      update_track = "stable"
    }

    backup_configuration {
      enabled            = true
      binary_log_enabled = true
    }

  }

  deletion_protection = false
}

resource "google_sql_database" "mlflow_cloudsql_database" {
  project  = var.project_name
  name     = "mlflow"
  instance = google_sql_database_instance.mlflow_cloudsql_instance.name
}

resource "google_sql_user" "mlflow_db_user" {
  project    = var.project_name
  name       = "mlflow"
  instance   = google_sql_database_instance.mlflow_cloudsql_instance.name
  password   = random_password.mlflow_db_password.result
  depends_on = [google_sql_database.mlflow_cloudsql_database]
}

resource "google_secret_manager_secret" "mlflow_db_password_secret" {
  project   = var.project_name
  secret_id = "${var.prefix}-mlflow-db-password-${var.env}-${var.region}"

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "mlflow_db_password_secret" {
  secret      = google_secret_manager_secret.mlflow_db_password_secret.id
  secret_data = random_password.mlflow_db_password.result
}

resource "google_secret_manager_secret_iam_member" "mlflow_db_password_secret_iam" {
  depends_on = [google_secret_manager_secret.mlflow_db_password_secret, google_project_service.services]
  secret_id  = google_secret_manager_secret.mlflow_db_password_secret.id
  role       = "roles/secretmanager.secretAccessor"
  for_each = toset(["serviceAccount:${var.project_number}-compute@developer.gserviceaccount.com",
    "serviceAccount:${var.project_name}@appspot.gserviceaccount.com",
    local.app_flex_sa
  ])
  member = each.key
}
