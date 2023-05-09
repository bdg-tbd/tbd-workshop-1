locals {
  notebook_subnet_name = "subnet-01"
  notebook_subnet_id   = "${var.region}/${local.notebook_subnet_name}"
  zone                 = "${var.region}-b"
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
      next_hop_internet = "true"
    }
  ]
}
module "cloud-router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 5.0.0"
  project = var.project_name
  region  = var.region
  network = module.vpc.network_id
  name    = "nat-router"
  nats = [{
    name = "nat-gateway"
  }]
}
#Enables IAP tunneling
resource "google_compute_firewall" "fw-allow-ingress-from-iap" {
  name          = "fw-allow-ingress-iap"
  network       = module.vpc.network_id
  priority      = 1000
  direction     = "INGRESS"
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22", "8443", "443", "80", "8000"]
  }

}


resource "google_notebooks_instance" "tbd_notebook" {
  depends_on   = [module.cloud-router]
  location     = local.zone
  machine_type = "e2-standard-2"
  name         = "${var.project_name}-notebook"
  container_image {
    repository = var.ai_notebook_image_repository
    tag        = var.ai_notebook_image_tag
  }
  network = module.vpc.network_id
  subnet  = module.vpc.subnets[local.notebook_subnet_id].id
  ## change it to break the checkov during the labs
  # FIXME:remove
  no_public_ip    = true
  no_proxy_access = true
  # end
  instance_owners = [var.ai_notebook_instance_owner]
}