# tbd-workshop-1
TBD workshop 1

## Project setup
1. Export shared environment variables
```bash
export TF_VAR_tbd_semester=2023L
# format: 20xx for teachers, 30xx for students 
export TF_VAR_user_id=2001
export TF_VAR_billing_account=016F99-F0B167-9A895D

```
2. Enter `bootstrap` folder then init project and Terraform state bucket
```bash
cd bootstrap
terraform init
terraform apply
cd ..
```
3. CI/CD (Github Actions setup)
* Edit `env/backend.tfvars` file and set `bucket` variable with the state bucket
* Edit `env/project.tfvars` file and set `project_name` variable
* Init state file and set env variables
```bash
cd cicd_bootstrap
terraform init -backend-config=../env/backend.tfvars
```
* Apply
```bash
gcloud auth configure-docker

terraform apply -var-file ../env/project.tfvars -var-file conf/github_actions.tfvars -compact-warnings
```

4. Use output variables for configuring Github Actions workflow: `.github/workflows/tech-tests.yml` 

5. Install and configure `pre-commit`<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.4.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.63.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_gcr"></a> [gcr](#module\_gcr) | ./modules/gcr | n/a |
| <a name="module_jupyter_docker_image"></a> [jupyter\_docker\_image](#module\_jupyter\_docker\_image) | ./modules/docker_image | n/a |
| <a name="module_vertex_ai_workbench"></a> [vertex\_ai\_workbench](#module\_vertex\_ai\_workbench) | ./modules/vertex-ai-workbench | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_notebook_instance_owner"></a> [ai\_notebook\_instance\_owner](#input\_ai\_notebook\_instance\_owner) | Vertex AI workbench owner | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
