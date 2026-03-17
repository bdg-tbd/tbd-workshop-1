variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "airflow_db_password" {
  type        = string
  default     = "postgres"
  sensitive   = true
  description = "Password for Airflow metadata PostgreSQL database"
}

variable "airflow_admin_password" {
  type        = string
  default     = "admin"
  sensitive   = true
  description = "Password for Airflow web UI admin user"
}

## Vertex AI Workbench has been replaced with Jupyter on Dataproc
#variable "ai_notebook_instance_owner" {
#  type        = string
#  description = "Vertex AI workbench owner"
#}