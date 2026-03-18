# airflow

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 7.24.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.airflow](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_container_node_pool.airflow_nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [google_project_iam_member.airflow_dataproc_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.airflow_sa_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.airflow_storage](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.container](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.airflow_sa](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type for GKE nodes | `string` | `"e2-standard-2"` | no |
| <a name="input_network"></a> [network](#input\_network) | VPC network name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | VPC subnet self\_link | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | GKE cluster CA certificate |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | GKE cluster endpoint |
| <a name="output_cluster_location"></a> [cluster\_location](#output\_cluster\_location) | GKE cluster location (zone) |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | GKE cluster name |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Airflow service account email |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
