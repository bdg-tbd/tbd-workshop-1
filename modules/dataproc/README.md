# dataproc

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.44.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dataproc_cluster.tbd-dataproc-cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataproc_cluster) | resource |
| [google_project_iam_member.dataproc_bigquery_data_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.dataproc_bigquery_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.dataproc_worker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.dataproc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.dataproc_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.dataproc_staging](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.dataproc_temp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.staging_bucket_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [google_storage_bucket_iam_member.temp_bucket_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | n/a | `string` | `"2.2.69-ubuntu22"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type to use for both worker and master nodes | `string` | `"e2-medium"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | VPC subnet used for deployment | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataproc_cluster_name"></a> [dataproc\_cluster\_name](#output\_dataproc\_cluster\_name) | Dataproc cluster name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
