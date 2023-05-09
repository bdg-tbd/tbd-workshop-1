# docker_image

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
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
| [docker_image.jupyter](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/image) | resource |
| [docker_registry_image.jupyterlab](https://registry.terraform.io/providers/kreuzwerker/docker/3.0.2/docs/resources/registry_image) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_jupyterlab_version"></a> [jupyterlab\_version](#input\_jupyterlab\_version) | Jupyterlab version | `string` | `"3.6.3"` | no |
| <a name="input_registry_hostname"></a> [registry\_hostname](#input\_registry\_hostname) | Image registry hostname | `string` | n/a | yes |
| <a name="input_registry_repo_name"></a> [registry\_repo\_name](#input\_registry\_repo\_name) | Image registry repository name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jupyter_image_name"></a> [jupyter\_image\_name](#output\_jupyter\_image\_name) | n/a |
| <a name="output_jupyter_image_uri"></a> [jupyter\_image\_uri](#output\_jupyter\_image\_uri) | Jupyterlab image URI |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
