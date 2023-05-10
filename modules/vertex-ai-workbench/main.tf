locals {
  zone = "${var.region}-b"
}

resource "google_project_service" "notebooks" {
  provider           = google
  service            = "notebooks.googleapis.com"
  disable_on_destroy = true
}




resource "google_storage_bucket_object" "post" {
  name   = "scripts/notebook_post_startup_script.sh"
  source = "resources/notebook_post_startup_script.sh"
  bucket = "image-store"
}



resource "google_notebooks_instance" "tbd_notebook" {
  depends_on   = [google_project_service.notebooks]
  location     = local.zone
  machine_type = "e2-standard-2"
  name         = "${var.project_name}-notebook"
  container_image {
    repository = var.ai_notebook_image_repository
    tag        = var.ai_notebook_image_tag
  }
  network = var.network
  subnet  = var.subnet
  ## change it to break the checkov during the labs
  # FIXME:remove
  no_public_ip    = true
  no_proxy_access = true
  # end
  instance_owners = [var.ai_notebook_instance_owner]
  #  post_startup_script =
}

