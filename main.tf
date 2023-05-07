locals {
  notebook_subnet_name = "subnet-01"
  notebook_subnet_id   = "${var.region}/${local.notebook_subnet_name}"
}

resource "google_project_service" "notebooks" {
  provider           = google
  service            = "notebooks.googleapis.com"
  disable_on_destroy = true
}

module "vpc" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 7.0"
  project_id   = var.project_name
  network_name = "main-vpc"
  routing_mode = "GLOBAL"
  subnets = [
    {
      subnet_name   = local.notebook_subnet_name
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
  ]
  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    }
  ]
}

resource "google_notebooks_instance" "tbd_notebook" {
  location     = "${var.region}-b"
  machine_type = "e2-standard-2"
  name         = "${var.project_name}-notebook"
  container_image {
    repository = "gcr.io/deeplearning-platform-release/base-cpu.py310"
    tag        = "m108"
  }
  network = module.vpc.network_id
  subnet  = module.vpc.subnets[local.notebook_subnet_id].id
}