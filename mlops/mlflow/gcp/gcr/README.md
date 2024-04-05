# gcr

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
| [google_container_registry.registry](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_registry) | resource |
| [google_project_service.api](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | GCR location | `string` | `"EU"` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_registry_hostname"></a> [registry\_hostname](#output\_registry\_hostname) | GCR image registry hostname |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
