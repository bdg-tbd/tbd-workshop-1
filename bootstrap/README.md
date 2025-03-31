## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project.tbd_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_iam_binding.tbd-editor-binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_service.tbd-service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.tbd-terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.tbd-state-bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing account a project is attached to | `string` | n/a | yes |
| <a name="input_group_id"></a> [group\_id](#input\_group\_id) | TBD project group id | `number` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | n/a | yes |
| <a name="input_tbd_semester"></a> [tbd\_semester](#input\_tbd\_semester) | TBD semester | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project identifier |
| <a name="output_terraform_state_bucket"></a> [terraform\_state\_bucket](#output\_terraform\_state\_bucket) | Terraform state bucket |
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.26.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 6.26.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_budget"></a> [budget](#module\_budget) | terraform-google-modules/project-factory/google//modules/budget | 18.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_monitoring_notification_channel.notification_channel](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_notification_channel) | resource |
| [google_project.tbd_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_iam_audit_config.tbd_project_audit](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_audit_config) | resource |
| [google_project_iam_member.tbd-editor-member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.tbd-editor-supervisors](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.tbd-service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.tbd-terraform](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_storage_bucket.tbd-state-bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | Billing account a project is attached to | `string` | n/a | yes |
| <a name="input_budget_amount"></a> [budget\_amount](#input\_budget\_amount) | Budget amount | `number` | `100` | no |
| <a name="input_budget_channels"></a> [budget\_channels](#input\_budget\_channels) | Budget notification channels | `map(string)` | <pre>{<br/>  "aleskandra-sypula": "aleksandra.sypula@gmail.com",<br/>  "lukasz-szarejko": "mslukaszsz@gmail.com",<br/>  "mateusz-wasilewski": "mateuszwasilewski77@gmail.com"<br/>}</pre> | no |
| <a name="input_budget_thresholds"></a> [budget\_thresholds](#input\_budget\_thresholds) | Budget thresholds | `list(number)` | <pre>[<br/>  0.1,<br/>  0.3,<br/>  0.5,<br/>  0.7,<br/>  0.9<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_tbd_semester"></a> [tbd\_semester](#input\_tbd\_semester) | TBD semester | `string` | n/a | yes |
| <a name="input_user_id"></a> [user\_id](#input\_user\_id) | TBD project group id | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_project_name"></a> [project\_name](#output\_project\_name) | Project identifier |
| <a name="output_terraform_service_account"></a> [terraform\_service\_account](#output\_terraform\_service\_account) | Terraform service account |
| <a name="output_terraform_state_bucket"></a> [terraform\_state\_bucket](#output\_terraform\_state\_bucket) | Terraform state bucket |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
