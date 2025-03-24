# dbt_docker_image

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_docker"></a> [docker](#provider\_docker) | 3.0.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [docker_image.dbt](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/image) | resource |
| [docker_registry_image.dbt](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/registry_image) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dbt_spark_version"></a> [dbt\_spark\_version](#input\_dbt\_spark\_version) | dbt-spark version | `string` | n/a | yes |
| <a name="input_dbt_version"></a> [dbt\_version](#input\_dbt\_version) | dbt core version | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_registry_hostname"></a> [registry\_hostname](#input\_registry\_hostname) | Image registry hostname | `string` | n/a | yes |
| <a name="input_registry_repo_name"></a> [registry\_repo\_name](#input\_registry\_repo\_name) | Image registry repository name | `string` | n/a | yes |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | Apache Spark version | `string` | `"3.3.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dbt_image_name"></a> [dbt\_image\_name](#output\_dbt\_image\_name) | n/a |
| <a name="output_dbt_image_uri"></a> [dbt\_image\_uri](#output\_dbt\_image\_uri) | Jupyterlab image URI |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
