# metastore

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

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dataproc_metastore_service.demo](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataproc_metastore_service) | resource |
| [google_project_service.api-metastore](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_metastore_version"></a> [metastore\_version](#input\_metastore\_version) | Hive Metastore version | `string` | `"3.1.2"` | no |
| <a name="input_network"></a> [network](#input\_network) | VPC to use for notebooks | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metastore_name"></a> [metastore\_name](#output\_metastore\_name) | Metastore server name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
