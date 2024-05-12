variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "ai_notebook_instance_owner" {
  type        = string
  description = "Vertex AI workbench owner"
}

variable "enable_composer" {
  type        = bool
  default     = true
  description = "Enable GCP Composer deployment and dependent modules"
}

variable "jupyter_image_flavour" {
  type        = string
  default     = "dataops"
  description = "Jupyterlab image flavour"
  validation {
    condition     = can(regex("^(dataops|mlops)$", var.jupyter_image_flavour))
    error_message = "Invalid image flavour. Supported values are dataops, mlops"
  }
}