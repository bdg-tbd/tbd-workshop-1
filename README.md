# TBD Workshop 1.

## Workshop goals
1. Learn how to provision computing resources for running Big Data analyses using the Infrastructure as Code (IaC) approach.
2. Learn how to set up opinionated CI/CD pipelines to deploy cloud infrastructure. 
3. Learn how to utilize linters for detecting security vulnerabilities in cloud infrastructure.
4. Learn how to run Apache Spark code in a distributed way on Hadoop cluster using
Vertex AI notebooks and Dataproc services on GCP.
5. Learn how to use Workload Identity Federation for a secure authentication from GitHub Actions
to Google Cloud.
![img.png](doc/figures/workload_id_federation.png)
## High level architecture
![img.png](doc/figures/hla.png)
## Prerequisites
### Software
* Google Cloud SDK ~>424.0.0
* gsutil ~>5.21
* pre-commit ~>2.15.0
* Terraform ~>1.4.0
* Python ~>3.8
* Linux/MacOS
* [pre-commit-terraform dependencies](https://github.com/antonbabenko/pre-commit-terraform)

### GCP
* Redeem a GCP coupon to create a billing account
* Authenticate to GCP to obtain the default credentials used for running the code
```bash
# first remove the stored credentials if exist
gcloud auth application-default revoke
# login and get the new application credentials
gcloud auth application-default login
```
## Project setup
1. Export shared environment variables
```bash
export TF_VAR_tbd_semester=2023L
# format: 20xx for teachers, student ID number for students 
export TF_VAR_user_id=2002
# use your own billing account id
export TF_VAR_billing_account=016F99-F0B167-9A895D

```
2. Enter `bootstrap` folder then init project and Terraform state bucket
```bash
cd bootstrap
terraform init
terraform apply
cd ..
```
3. CI/CD (Github Actions setup using [Workload Identity Federation](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions))
* Edit `env/backend.tfvars` file and set `bucket` variable with the Terraform state bucket
* Edit `env/project.tfvars` file and set `project_name`, `iac_service_account` variables using the output from the `bootstrap` phase, e.g.:
![img.png](doc/figures/bootstrap-output.png)
* Edit `cicd_bootstrap/conf/github_actions.tfvars` to set `github_org` and `github_repo`, e.g.:
```text
  github_org  = "mwiewior"
  github_repo = "tbd-workshop-1"
```
* Init state file and set env variables
```bash
cd cicd_bootstrap
terraform init -backend-config=../env/backend.tfvars
```
* Apply
```bash
# authenticate Docker backend with GCP
gcloud auth configure-docker
# create CI/CD integration using Workload Identity
terraform apply -var-file ../env/project.tfvars -var-file conf/github_actions.tfvars -compact-warnings
cd ..
```

4. Use output variables for configuring Github Actions workflow: `.github/workflows/pull-request.yml`,e.g. :
![img.png](doc/figures/workload-identity.png)
Please do not edit and hardcode these values in a YAML but set the Github Actions secrets instead
while preserving the secret names, i.e. `GCP_WORKLOAD_IDENTITY_PROVIDER_NAME` and `GCP_WORKLOAD_IDENTITY_SA_EMAIL`.
![img.png](doc/figures/secrets.png)
5. Install and configure `pre-commit`
```bash
pre-commit install
```

6. Commit changes, push to a branch and open a PR to **YOUR** repository main/master branch.
If you see a warning like this -- please enable the workflows:
![img.png](doc/figures/workflow.png)
   ...and repush your changes!
If pre-commit linters report any issues please try to **fix** them :hammer_and_wrench:.
Once all Pull Requests checks **have passed** please merge your PR and wait until your release job finishes.
7. Navigate to the Vertex AI Workbench menu item, find your notebook on the list, press **CONNECT** and follow
the instructions
![img.png](doc/figures/workbench.png)

8. In your Jupyterlab enviroment add Python3.8 kernel:
```bash
python3.8 -m ipykernel install --user --name pyspark
```
9. Run a `Hello-world` PySpark application in a YARN-client mode:
![img.png](doc/figures/pyspark.png)

10. Additional tasks using Terraform:
<ol type="a">
 <li>Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance</li>
 <li>Add support for preemptible/spot instances in a Dataproc cluster</li>
 <li>Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot</li>
 <li>(Optional) Get access to Apache Spark WebUI</li>
</ol>


11. In the Jupyterlab terminal get OIDC token
```bash
export IAP_CLIENT_ID="171578482470-oqdpdqi6rc8ma8i6redoso4hsq7tg4k7.apps.googleusercontent.com"
export OIDC_TOKEN=$(curl -s -X POST -H "content-type: application/json" -H "Authorization: Bearer $(gcloud auth print-access-token)" -d "{\"audience\": \"${IAP_CLIENT_ID}\", \"includeEmail\": true }" "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/$(gcloud auth list --filter=status:ACTIVE --format='value(account)'):generateIdToken"  | jq -r '.token')
```

5**IMPORTANT**
:exclamation: :exclamation: :exclamation: Please remember to **destroy all** the resources after the workshop:

```bash
terraform destroy -no-color -var-file env/project.tfvars 
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| <a name="module_dataproc"></a> [dataproc](#module\_dataproc) | ./modules/dataproc | n/a |
| <a name="module_gcr"></a> [gcr](#module\_gcr) | ./modules/gcr | n/a |
| <a name="module_jupyter_docker_image"></a> [jupyter\_docker\_image](#module\_jupyter\_docker\_image) | ./modules/docker_image | n/a |
| <a name="module_vertex_ai_workbench"></a> [vertex\_ai\_workbench](#module\_vertex\_ai\_workbench) | ./modules/vertex-ai-workbench | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

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
