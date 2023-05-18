
resource "google_storage_bucket" "mlflow_artifacts_bucket" {
  #checkov:skip=CKV_GCP_114: "Ensure public access prevention is enforced on Cloud Storage bucket"
  #checkov:skip=CKV_GCP_62: "Bucket should log access"
  #checkov:skip=CKV_GCP_78: "Ensure Cloud storage has versioning enabled"
  name                        = "${var.prefix}-mlflow-${var.env}-${var.region}"
  location                    = substr(var.region, 0, 2) == "eu" ? "EU" : "US"
  storage_class               = "MULTI_REGIONAL"
  uniform_bucket_level_access = true
}




resource "google_storage_bucket_iam_member" "mlflow_artifacts_bucket_iam" {
  #checkov:skip=CKV_GCP_28: "Ensure that Cloud Storage bucket is not anonymously or publicly accessible"
  depends_on = [google_project_service.services]
  bucket     = google_storage_bucket.mlflow_artifacts_bucket.name
  role       = "roles/storage.objectAdmin"
  for_each   = toset([local.app_flex_sa, "allAuthenticatedUsers"])
  member     = each.key
}




