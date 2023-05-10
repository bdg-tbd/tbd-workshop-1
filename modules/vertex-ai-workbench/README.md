# vertex-ai-workbench

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.63.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.63.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_notebooks_instance.tbd_notebook](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/notebooks_instance) | resource |
| [google_project_service.notebooks](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_notebook_image_repository"></a> [ai\_notebook\_image\_repository](#input\_ai\_notebook\_image\_repository) | n/a | `string` | `"gcr.io/deeplearning-platform-release/base-cpu.py310"` | no |
| <a name="input_ai_notebook_image_tag"></a> [ai\_notebook\_image\_tag](#input\_ai\_notebook\_image\_tag) | n/a | `string` | `"latest"` | no |
| <a name="input_ai_notebook_instance_owner"></a> [ai\_notebook\_instance\_owner](#input\_ai\_notebook\_instance\_owner) | Vertex AI workbench owner | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | VPC to use for notebooks | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | VPC subnet to use for notebooks | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
