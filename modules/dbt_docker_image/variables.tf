variable "registry_hostname" {
  type        = string
  description = "Image registry hostname"
}

variable "registry_repo_name" {
  type        = string
  description = "Image registry repository name"
}

variable "dbt_version" {
  type        = string
  description = "dbt core version"
  default     = "1.7.3"
}

variable "dbt_spark_version" {
  type        = string
  description = "dbt-spark version"
  default     = "1.7.1"
}

variable "spark_version" {
  type        = string
  description = "Apache Spark version"
  default     = "3.3.2"
}

variable "project_name" {
  type        = string
  description = "Project name"
}
