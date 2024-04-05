# app_engine

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.23.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.23.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.23.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | 5.23.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_service_networking_connection.private_vpc_connection](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_service_networking_connection) | resource |
| [google_app_engine_flexible_app_version.mlflow_default_app](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/app_engine_flexible_app_version) | resource |
| [google_compute_global_address.private_ip_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_iap_web_type_app_engine_iam_binding.binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_type_app_engine_iam_binding) | resource |
| [google_project_iam_member.mlflow_gae_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.service_networking](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project_service.services](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret.mlflow_db_password_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret) | resource |
| [google_secret_manager_secret_iam_member.mlflow_db_password_secret_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_secret_manager_secret_version.mlflow_db_password_secret](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_version) | resource |
| [google_sql_database.mlflow_cloudsql_database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) | resource |
| [google_sql_database_instance.mlflow_cloudsql_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) | resource |
| [google_sql_user.mlflow_db_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_user) | resource |
| [google_storage_bucket.mlflow_artifacts_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_iam_member.mlflow_artifacts_bucket_iam](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_member) | resource |
| [random_id.db_name_suffix](https://registry.terraform.io/providers/hashicorp/random/3.1.2/docs/resources/id) | resource |
| [random_password.mlflow_db_password](https://registry.terraform.io/providers/hashicorp/random/3.1.2/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_type"></a> [availability\_type](#input\_availability\_type) | n/a | `string` | `"ZONAL"` | no |
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | n/a | `string` | `"db-g1-small"` | no |
| <a name="input_mlflow_docker_image_uri"></a> [mlflow\_docker\_image\_uri](#input\_mlflow\_docker\_image\_uri) | TBD | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | TBD | <pre>object({ network_id = string<br>  network_name = string })</pre> | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | n/a | `string` | n/a | yes |
| <a name="input_project_number"></a> [project\_number](#input\_project\_number) | n/a | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | TBD | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mlflow_appengine_url"></a> [mlflow\_appengine\_url](#output\_mlflow\_appengine\_url) | n/a |
| <a name="output_mlflow_artifacts_bucket_name"></a> [mlflow\_artifacts\_bucket\_name](#output\_mlflow\_artifacts\_bucket\_name) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
