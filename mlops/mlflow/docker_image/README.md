# docker_image

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
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
| [docker_image.mlflow](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/image) | resource |
| [docker_registry_image.mlflow](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/registry_image) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_mlflow_version"></a> [mlflow\_version](#input\_mlflow\_version) | MLflow version | `string` | `"2.3.1"` | no |
| <a name="input_registry_hostname"></a> [registry\_hostname](#input\_registry\_hostname) | Image registry hostname | `string` | n/a | yes |
| <a name="input_registry_repo_name"></a> [registry\_repo\_name](#input\_registry\_repo\_name) | Image registry repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_mlflow_image_uri"></a> [mlflow\_image\_uri](#output\_mlflow\_image\_uri) | MLflow imager URI |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
