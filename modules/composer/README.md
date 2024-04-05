<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_composer"></a> [composer](#module\_composer) | terraform-google-modules/composer/google//modules/create_environment_v2 | ~> 5.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_subnetwork.composer-subnet](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) | resource |
| [google_project_iam_member.composer-member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.dataproc-editor-iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.dataproc-sa-user-iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.tbd-composer-sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Composer env name | `string` | `"demo-lab"` | no |
| <a name="input_env_size"></a> [env\_size](#input\_env\_size) | Environment size | `string` | `"ENVIRONMENT_SIZE_SMALL"` | no |
| <a name="input_env_variables"></a> [env\_variables](#input\_env\_variables) | Apache Airflow variables to set | `map(string)` | n/a | yes |
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | n/a | `string` | `"composer-2.4.6-airflow-2.6.3"` | no |
| <a name="input_network"></a> [network](#input\_network) | VPC to use for notebooks | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet_address"></a> [subnet\_address](#input\_subnet\_address) | VPC subnet used for deployment | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Composer subnet name | `string` | `"composer-subnet-01"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_data_service_account"></a> [data\_service\_account](#output\_data\_service\_account) | Apache Airflow service account |
| <a name="output_gcs_bucket"></a> [gcs\_bucket](#output\_gcs\_bucket) | GCS bucket for storing Apache Airflow DAGs |
| <a name="output_gke_cluster"></a> [gke\_cluster](#output\_gke\_cluster) | Composer underlying GKE cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
