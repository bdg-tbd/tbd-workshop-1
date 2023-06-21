# Introduction to Cloud Computing 

## Workshop goals
1. Learn how to obtain cloud credits (GCP, Azzure, AWS, Academic clouds)
2. Learn how to use GCP console (IAM, Compute engine, cloud storage, k8s, vertexAI, budgets)
3. Learn how to provision computing resources for running Big Data analyses using the Infrastructure as Code (IaC) approach.
4. Learn how to set up opinionated CI/CD pipelines to deploy cloud infrastructure. 
5. Learn how to utilize linters for detecting security vulnerabilities in cloud infrastructure.
6. Learn how to run Apache Spark code in a distributed way on Hadoop cluster using Vertex AI notebooks and Dataproc services on GCP.
7. Learn how to use Workload Identity Federation for a secure authentication from GitHub Actions
to Google Cloud.
![img.png](../..//doc/figures/workload_id_federation.png)
## High level architecture
![img.png](../../doc/figures/hla.png)
## Prerequisites
### Docker
* docker
* docker-compose
### GCP
* Redeem a GCP coupon to create a billing account

## OpenVsCode setup
* Fork this repo
![img.png](../../doc/figures/fork.png)
* Clone your fork of this repo. Replace <user_name> with your github login
```bash
cd ~ 
git clone https://github.com/<user_name>/tbd-workshop-1.git 
```
* Run docker-compose
```bash
service docker start  # (optionally on thx) 
cd tbd-workshop-1/devel/ 
docker-compose up -d 
```
* Open web browser (e.g. google-chrome) and open the following link
```bash
 localhost:3000
```
* You should see:
![img.png](../../doc/figures/vscode.png)
## Github setup
* Open Terminal in OpenVsCode (left corner -> Terminal -> New terminal)
* In the terminal run
```bash
 sudo apt-get install openssh-client 
 # generate ssh-key (change to your email address)
 ssh-keygen -t ed25519 -C tgambin@gmail.com 
```
* Copy ssh-key to your clipboard and follow the instruction to add your ssh-key to your github account:
* [https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account?tool=webui]
* Run in OpenVsCode terminal. Change your name and email:
```bash
git config --global user.name "Tomasz Gambin" 
git config --global user.email tgambin@gmail.com 
```
* Clone once again your fork of this repo (this time in OpenVsCode terminal):
```bash
cd ~
git clone git@github.com:<user_name>/tbd-workshop-1.git 
```
## GCP setup
* Authenticate to GCP to obtain the default credentials used for running the code
```bash
# first remove the stored credentials if exist
gcloud auth application-default revoke
# login and get the new application credentials
gcloud auth application-default login
```
  

## Project setup
1. Export shared environment variables. IMPORTANT:
   - Replace 'Tomasz Gambin' with your name.
   - Replace 01E498-FCE608-11EF17 with your billing account
```bash
export TF_VAR_tbd_semester=2023L
# replace Tomasz Gambin with your name
export TF_VAR_user_id=$(echo -n "Tomasz Gambin" | tr '[:upper:]' '[:lower:]' | grep -o . | LC_ALL=C sort | tr -d '\n' | cksum | awk '{printf "%05d\n", $1 % 100000}')  
# use your own billing account id
export TF_VAR_billing_account=01E498-FCE608-11EF17

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
![img.png](../../doc/figures/bootstrap-output.png)
* Edit `cicd_bootstrap/conf/github_actions.tfvars` to set `github_org` and `github_repo`, e.g.:
```text
  github_org  = "tgambin"
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
![img.png](../../doc/figures/workload-identity.png)
Please do not edit and hardcode these values in a YAML but set the Github Actions secrets instead
while preserving the secret names, i.e. `GCP_WORKLOAD_IDENTITY_PROVIDER_NAME` and `GCP_WORKLOAD_IDENTITY_SA_EMAIL`.
![img.png](../../doc/figures/secrets.png)
5. Install and configure `pre-commit`
```bash
pre-commit install
```

6. Commit changes, push to a branch and open a PR to **YOUR** repository main/master branch.
If you see a warning like this -- please enable the workflows:
![img.png](../../doc/figures/workflow.png)
...and repush your changes!

Once all Pull Requests checks **have passed** please merge your PR and wait until your release job finishes.
7. Navigate to the Vertex AI Workbench menu item, find your notebook on the list, press **CONNECT** and follow
the instructions
![img.png](../../doc/figures/workbench.png)

8. In your Jupyterlab enviroment add Python3.8 kernel:
```bash
python3.8 -m ipykernel install --user --name pyspark
```
9. Run a `Hello-world` PySpark application in a YARN-client mode:
![img.png](../../doc/figures/pyspark.png)

10. Additional tasks using Terraform:
<ol type="a">
 <li>Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance</li>
 <li>Add support for preemptible/spot instances in a Dataproc cluster</li>
 <li>Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot</li>
 <li>(Optional) Get access to Apache Spark WebUI</li>
</ol>




11. **IMPORTANT**
:exclamation: :exclamation: :exclamation: Please remember to **destroy all** the resources after the workshop:

a) using a Github Action (preferred)
![img.png](../../doc/figures/destroy-workflow.png)

b) or running Terraform destroy command locally
```bash
terraform init -backend-config=env/backend.tfvars
terraform destroy -no-color -var-file env/project.tfvars 
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
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
