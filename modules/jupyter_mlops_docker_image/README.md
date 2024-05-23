# jupyter_mlops_docker_image

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
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
| [docker_image.jupyter-mlops](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/image) | resource |
| [docker_registry_image.jupyterlab](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/registry_image) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dbt_spark_version"></a> [dbt\_spark\_version](#input\_dbt\_spark\_version) | dbt-spark version | `string` | n/a | yes |
| <a name="input_dbt_version"></a> [dbt\_version](#input\_dbt\_version) | dbt core version | `string` | n/a | yes |
| <a name="input_gcs_connector_version"></a> [gcs\_connector\_version](#input\_gcs\_connector\_version) | GCS connector version | `string` | `"2.2.17"` | no |
| <a name="input_jupyterlab_version"></a> [jupyterlab\_version](#input\_jupyterlab\_version) | Jupyterlab version | `string` | `"4.1.6"` | no |
| <a name="input_kedro_version"></a> [kedro\_version](#input\_kedro\_version) | Kedro version | `string` | n/a | yes |
| <a name="input_mlflow_version"></a> [mlflow\_version](#input\_mlflow\_version) | MLflow version | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_registry_hostname"></a> [registry\_hostname](#input\_registry\_hostname) | Image registry hostname | `string` | n/a | yes |
| <a name="input_registry_repo_name"></a> [registry\_repo\_name](#input\_registry\_repo\_name) | Image registry repository name | `string` | n/a | yes |
| <a name="input_spark_version"></a> [spark\_version](#input\_spark\_version) | Apache Spark version | `string` | `"3.3.2"` | no |
| <a name="input_vs_code_version"></a> [vs\_code\_version](#input\_vs\_code\_version) | VSCode Server version | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jupyter_image_name"></a> [jupyter\_image\_name](#output\_jupyter\_image\_name) | n/a |
| <a name="output_jupyter_image_uri"></a> [jupyter\_image\_uri](#output\_jupyter\_image\_uri) | Jupyterlab image URI |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
