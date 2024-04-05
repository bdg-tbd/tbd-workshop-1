# vpc

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
| <a name="module_cloud-router"></a> [cloud-router](#module\_cloud-router) | terraform-google-modules/cloud-router/google | ~> 6.0.1 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google | ~> 9.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.default-internal-allow-all](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.fw-allow-ingress-from-iap](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | VPC name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet_address"></a> [subnet\_address](#input\_subnet\_address) | n/a | `string` | `"10.10.10.0/24"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | VPC subnet name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | VPC id |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | VPC subnets map |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
