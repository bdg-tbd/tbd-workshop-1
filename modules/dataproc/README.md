# dataproc

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.44.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_dataproc_cluster.tbd-dataproc-cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataproc_cluster) | resource |
| [google_project_service.dataproc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_image_version"></a> [image\_version](#input\_image\_version) | n/a | `string` | `"2.1.27-ubuntu20"` | no |
| <a name="input_master_machine_type"></a> [master\_machine\_type](#input\_master\_machine\_type) | Master Machine type | `string` | `"e2-medium"` | no |
| <a name="input_num_worker_nodes"></a> [num\_worker\_nodes](#input\_num\_worker\_nodes) | Number of worker nodes in the Dataproc cluster | `number` | `2` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | VPC subnet used for deployment | `string` | n/a | yes |
| <a name="input_worker_machine_type"></a> [worker\_machine\_type](#input\_worker\_machine\_type) | Worker Machine type | `string` | `"e2-medium"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataproc_cluster_name"></a> [dataproc\_cluster\_name](#output\_dataproc\_cluster\_name) | Dataproc cluster name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
