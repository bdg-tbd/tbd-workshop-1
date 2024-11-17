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
| <a name="input_master_machine_type"></a> [master\_machine\_type](#input\_master\_machine\_type) | Machine type to use for master nodes | `string` | `"e2-medium"` | no |
| <a name="input_master_num_instances"></a> [master\_num\_instances](#input\_master\_num\_instances) | Number of master nodes | `number` | `1` | no |
| <a name="input_preemptible_worker_num_instances"></a> [preemptible\_worker\_num\_instances](#input\_preemptible\_worker\_num\_instances) | Number of preemptible worker nodes | `number` | `0` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |
| <a name="input_subnet"></a> [subnet](#input\_subnet) | VPC subnet used for deployment | `string` | n/a | yes |
| <a name="input_worker_machine_type"></a> [worker\_machine\_type](#input\_worker\_machine\_type) | Machine type to use for worker nodes | `string` | `"e2-medium"` | no |
| <a name="input_worker_num_instances"></a> [worker\_num\_instances](#input\_worker\_num\_instances) | Number of worker nodes | `number` | `2` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataproc_cluster_name"></a> [dataproc\_cluster\_name](#output\_dataproc\_cluster\_name) | Dataproc cluster name |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
