# Deploy dummy app as [workaround](https://stackoverflow.com/questions/37679552/cannot-delete-version)
```bash
gcloud config set project tbd-2023l-mlops
gcloud app deploy default-app/app.yaml
```
```bash
terraform init -backend-config=../env/backend.tfvars
terraform apply -var-file=../env/project.tfvars
```<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.23.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcp_mlflow_appengine"></a> [gcp\_mlflow\_appengine](#module\_gcp\_mlflow\_appengine) | ./mlflow/gcp/app_engine | n/a |
| <a name="module_gcp_registry"></a> [gcp\_registry](#module\_gcp\_registry) | ./mlflow/gcp/gcr | n/a |
| <a name="module_gcp_vpc"></a> [gcp\_vpc](#module\_gcp\_vpc) | terraform-google-modules/network/google | 9.0.0 |
| <a name="module_mlflow_docker_image"></a> [mlflow\_docker\_image](#module\_mlflow\_docker\_image) | ./mlflow/docker_image | n/a |

## Resources

| Name | Type |
|------|------|
| [google_project_service.compute](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
