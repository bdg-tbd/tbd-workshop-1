variable "registry_hostname" {
  type        = string
  description = "Image registry hostname"
}

variable "registry_repo_name" {
  type        = string
  description = "Image registry repository name"
}

variable "jupyterlab_version" {
  type        = string
  description = "Jupyterlab version"
  default     = "4.1.6"
}

variable "spark_version" {
  type        = string
  description = "Apache Spark version"
  default     = "3.3.2"
}

variable "gcs_connector_version" {
  type        = string
  description = "GCS connector version"
  default     = "2.2.17"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

variable "dbt_version" {
  type        = string
  description = "dbt core version"
}

variable "dbt_spark_version" {
  type        = string
  description = "dbt-spark version"
}

variable "mlflow_version" {
  type        = string
  description = "MLflow version"
}

variable "kedro_version" {
  type        = string
  description = "Kedro version"
}

variable "vs_code_version" {
  type        = string
  description = "VSCode Server version"
}






