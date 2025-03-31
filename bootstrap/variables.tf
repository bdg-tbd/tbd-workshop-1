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
  default     = "europe-west1"
  description = "GCP region"
}

variable "budget_amount" {
  type        = number
  description = "Budget amount"
  default     = 100
}

variable "budget_thresholds" {
  type        = list(number)
  description = "Budget thresholds"
  default     = [0.1, 0.3, 0.5, 0.7, 0.9]
}

variable "budget_channels" {
  type        = map(string)
  description = "Budget notification channels"
  default = {
    filip-kiernozek : "kiernozek16@gmail.com"
    michal-laskowski : "01158164@pw.edu.pl"
    dpalyska : "01169221@pw.edu.pl"
  }
}
