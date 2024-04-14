variable "tbd_semester" {
  type        = string
  description = "TBD semester"
}

variable "user_id" {
  type        = number
  description = "TBD project group id"
}
variable "billing_account" {
  type        = string
  description = "Billing account a project is attached to"
}
variable "region" {
  type        = string
  default     = "europe-central2"
  description = "GCP region"
}