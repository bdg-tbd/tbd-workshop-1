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
terraform apply -var-file ../env/project.tfvars -var-file conf/github_actions.tfvars -compact-warnings
```

4. Use output variables for configuring Github Actions workflow: `.github/workflows/tech-tests.yml` 

5. Install and configure `pre-commit`