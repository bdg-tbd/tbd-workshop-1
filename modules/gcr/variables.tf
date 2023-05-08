variable "project" {
  type        = string
  description = "GCP project name"
}

variable "location" {
  type        = string
  description = "GCR location"
  default     = "EU"
}