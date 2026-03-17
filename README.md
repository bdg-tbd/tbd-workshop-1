# TBD Workshop 1.

## Workshop goals
1. Learn how to provision computing resources for running Big Data analyses using the Infrastructure as Code (IaC) approach.
2. Learn how to set up opinionated CI/CD pipelines to deploy cloud infrastructure. 
3. Learn how to utilize linters for detecting security vulnerabilities in cloud infrastructure.
4. Learn how to run Apache Spark code in a distributed way on Hadoop cluster using
Jupyter notebooks and Dataproc services on GCP.
5. Learn how to use Workload Identity Federation for a secure authentication from GitHub Actions
to Google Cloud.
![img.png](doc/figures/workload_id_federation.png)
## High level architecture
![img.png](doc/figures/hla.png)
## Prerequisites
### Software
* Google Cloud SDK
* terraform ~> 1.11.0 
* gsutil
* pre-commit
* Terraform ( [Requirements](#Requirements) )
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
0. Fork this repository to your own Github account.
1. Export shared environment variables
```bash
export TF_VAR_tbd_semester=2026L
# format: 20xx for teachers, student ID number for students
export TF_VAR_user_id=<your_student_id>
# use your own billing account id
export TF_VAR_billing_account=<your_billing_account_id>
# for budget creation — REQUIRED for bootstrap to succeed
export GOOGLE_BILLING_PROJECT=$(echo "tbd-${TF_VAR_tbd_semester}-${TF_VAR_user_id}" | tr '[:upper:]' '[:lower:]')
```

2. Enter `bootstrap` folder then init project and Terraform state bucket
```bash
cd bootstrap
terraform init
terraform apply
cd ..
```

3. **Request quota increase** (before deploying main infrastructure)

Go to GCP Console → IAM & Admin → Quotas and request increase for:
* `CPUS_ALL_REGIONS` → at least **24** (default 12 is not enough for Dataproc + GKE)

4. CI/CD (Github Actions setup using [Workload Identity Federation](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions))
* Edit `env/backend.tfvars` file and set `bucket` variable with the Terraform state bucket
* Edit `env/project.tfvars` file and set `project_name` and `iac_service_account` using the output from the `bootstrap` phase, e.g.:
![img.png](doc/figures/bootstrap-output.png)
* In the same `env/project.tfvars` file, set the GitHub variables for Airflow git-sync (DAG files are synced automatically from your repo):
```text
  github_org    = "your-github-username"
  github_repo   = "tbd-workshop-1"
  github_branch = "master"
```
  `github_org` and `github_repo` should match your forked repository. `github_branch` controls which branch Airflow syncs DAGs from (default: `master`).
* Edit `cicd_bootstrap/conf/github_actions.tfvars` to set `github_org` and `github_repo`, e.g.:
```text
  github_org  = "your-github-username"
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

5. Use output variables for configuring Github Actions workflow: `.github/workflows/pull-request.yml`,e.g. :
![img.png](doc/figures/workload-identity.png)
Please do not edit and hardcode these values in a YAML but set the Github Actions secrets instead
while preserving the secret names, i.e. `GCP_WORKLOAD_IDENTITY_PROVIDER_NAME` and `GCP_WORKLOAD_IDENTITY_SA_EMAIL`.
![img.png](doc/figures/secrets.png)

Also, set the `INFRACOST_API_KEY` secret. Register at infracost.io to obtain your API key.

6. Install and configure `pre-commit`
```bash
pip install pre-commit   # if not already installed
pre-commit install
```

7. Commit changes, push to a branch and open a PR to **YOUR** repository master branch.
If you see a warning like this -- please enable the workflows:
![img.png](doc/figures/workflow.png)
...and repush your changes!

Once all Pull Requests checks **have passed** please merge your PR and wait until your release job finishes.

8. **IMPORTANT**
:exclamation: :exclamation: :exclamation: Please remember to **destroy all** the resources after the workshop:

```bash
terraform init -backend-config=env/backend.tfvars
terraform destroy -no-color -var-file env/project.tfvars 
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.11.0 |
| <a name="requirement_docker"></a> [docker](#requirement\_docker) | 3.0.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.44.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.24.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.44.2 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.24.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_composer"></a> [composer](#module\_composer) | ./modules/composer | n/a |
| <a name="module_data-pipelines"></a> [data-pipelines](#module\_data-pipelines) | ./modules/data-pipeline | n/a |
| <a name="module_dataproc"></a> [dataproc](#module\_dataproc) | ./modules/dataproc | n/a |
| <a name="module_dbt_docker_image"></a> [dbt\_docker\_image](#module\_dbt\_docker\_image) | ./modules/dbt_docker_image | n/a |
| <a name="module_gcr"></a> [gcr](#module\_gcr) | ./modules/gcr | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.allow-all-internal](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [kubernetes_service.dbt-task-service](https://registry.terraform.io/providers/hashicorp/kubernetes/2.24.0/docs/resources/service) | resource |
| [google_client_config.provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_container_cluster.composer-gke-cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west1"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Prerequisites — what you need to know before starting the TBD workshop                                                                                                                                    
                                                                                                                                                                                                               
  ### 1. Terraform (Infrastructure as Code)                                                                                                                                                                    
   
  Core concepts: providers, resources, modules, variables, outputs, state, `plan`/`apply`/`destroy`.                                                                                                           
   
  - [Official Getting Started](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started)                                                                                                            
  - [Terraform with GCP — tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build)
  - [Modules](https://developer.hashicorp.com/terraform/language/modules)                                                                                                                                      
  - [`terraform graph` — visualizing infrastructure](https://developer.hashicorp.com/terraform/cli/commands/graph)                                                                                             
                                                                                                                                                                                                               
  ### 2. GitHub Actions (CI/CD)                                                                                                                                                                                
                                                                                                                                                                                                               
  Understand workflows, jobs, steps, triggers (`on: push`, `pull_request`, `schedule`, `workflow_dispatch`), secrets, and permissions.                                                                         
   
  - [GitHub Actions Quickstart](https://docs.github.com/en/actions/quickstart)                                                                                                                                 
  - [Workflow syntax reference](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
  - [Using secrets in workflows](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)                                                               
  - [Scheduled events (`cron`)](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#schedule)                                                                                     
                                                                                                                                                                                                               
  ### 3. Workload Identity Federation (keyless GCP auth from GitHub Actions)                                                                                                                                   
                                                                                                                                                                                                               
  This replaces service account keys with short-lived tokens. Understand why it's more secure.                                                                                                                 
   
  - [Google Cloud blog — Enabling keyless authentication from GitHub Actions](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)                    
  - [google-github-actions/auth](https://github.com/google-github-actions/auth#workload-identity-federation-through-a-service-account)
                                                                                                                                                                                                               
  ### 4. Checkov (IaC security scanning)                                                                                                                                                                       
                                                                                                                                                                                                               
  Static analysis tool that detects misconfigurations in Terraform code (e.g. public buckets, missing encryption).                                                                                             
   
  - [Checkov Getting Started](https://www.checkov.io/1.Welcome/Quick%20Start.html)                                                                                                                             
  - [Suppressing checks with inline comments](https://www.checkov.io/2.Basics/Suppressing%20and%20Skipping%20Policies.html)                                                                                    
                                                                                                                                                                                                               
  ### 5. Infracost (cloud cost estimation)                                                                                                                                                                     
                                                                                                                                                                                                               
  Estimates infrastructure costs from Terraform code and posts diffs on pull requests.                                                                                                                         
   
  - [Infracost Getting Started](https://www.infracost.io/docs/)                                                                                                                                                
  - [Usage-based resources](https://www.infracost.io/docs/features/usage_based_resources/)
  - [Usage file example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml)                                                                                                       
                                                                                                                                                                                                               
  ### 6. Pre-commit hooks                                                                                                                                                                                      
                                                                                                                                                                                                               
  Automated code quality checks that run before each commit (formatting, linting, docs generation).                                                                                                            
   
  - [pre-commit framework](https://pre-commit.com/)                                                                                                                                                            
  - [pre-commit-terraform](https://github.com/antonbabenko/pre-commit-terraform) — used in this project for `terraform fmt`, `terraform validate`, `terraform-docs`
                                                                                                                                                                                                               
  ### 7. Hadolint (Dockerfile linting)                                                                                                                                                                         
                                                                                                                                                                                                               
  Lints Dockerfiles against best practices.                                                                                                                                                                    

  - [Hadolint on GitHub](https://github.com/hadolint/hadolint)                                                                                                                                                 
   
  ### 8. Apache Spark / PySpark (distributed data processing)                                                                                                                                                  
   
  Basics: SparkSession, DataFrames, reading/writing data (BigQuery, ORC format).                                                                                                                               
   
  - [PySpark Getting Started](https://spark.apache.org/docs/latest/api/python/getting_started/index.html)                                                                                                      
  - [Spark on Dataproc](https://cloud.google.com/dataproc/docs/tutorials/spark-scala)
                                                                                                                                                                                                               
  ### 9. Apache Airflow (workflow orchestration)                                                                                                                                                               
                                                                                                                                                                                                               
  Understand DAGs, operators (especially `DataprocSubmitJobOperator`), variables, connections.                                                                                                                 
   
  - [Airflow Core Concepts](https://airflow.apache.org/docs/apache-airflow/stable/core-concepts/index.html)                                                                                                    
  - [DataprocSubmitJobOperator](https://airflow.apache.org/docs/apache-airflow-providers-google/stable/operators/cloud/dataproc.html#submit-a-job-to-a-dataproc-cluster)
                                                                                                                                                                                                               
  ### 10. BigQuery (data warehouse)
                                                                                                                                                                                                               
  Creating datasets, external tables, querying ORC files stored in GCS.                                                                                                                                        
   
  - [BigQuery Quickstart (bq CLI)](https://cloud.google.com/bigquery/docs/bq-command-line-tool)                                                                                                                
  - [External tables over Cloud Storage](https://cloud.google.com/bigquery/docs/external-data-cloud-storage)
                                                                                                                                                                                                               
  ### 11. Semantic Release (automated versioning)                                                                                                                                                              
                                                                                                                                                                                                               
  Generates version numbers and releases from commit messages (used in the `release.yml` workflow).                                                                                                             
  - [semantic-release](https://github.com/semantic-release/semantic-release)                                                                                                                                   
  
