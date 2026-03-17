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

variable "github_org" {
  type        = string
  description = "GitHub organization or user owning the forked workshop repo"
}

variable "github_repo" {
  type        = string
  default     = "tbd-workshop-1"
  description = "GitHub repository name for the forked workshop repo"
}

variable "github_branch" {
  type        = string
  default     = "master"
  description = "GitHub branch for Airflow git-sync DAG syncing"
}

## Vertex AI Workbench has been replaced with Jupyter on Dataproc
#variable "ai_notebook_instance_owner" {
#  type        = string
#  description = "Vertex AI workbench owner"
#}