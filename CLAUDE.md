# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

University workshop for Infrastructure as Code (IaC), CI/CD, and distributed data processing on Google Cloud Platform. Students provision GCP infrastructure using Terraform, run Spark jobs on Dataproc, orchestrate with Airflow on GKE (Helm chart), and transform data with dbt.

## Tech Stack

- **IaC**: Terraform ~1.11.0 with Google provider ~5.44.0
- **Cloud**: GCP (Dataproc, GKE, GCS, BigQuery, Artifact Registry)
- **Data**: Apache Spark 3.5.1, dbt 1.8.7 (Spark adapter), Apache Airflow (Helm on GKE Standard)
- **CI/CD**: GitHub Actions with Workload Identity Federation (keyless GCP auth)
- **Containers**: Docker images for dbt, Jupyter, and dev environment (openvscode-server)

## Common Commands

```bash
# Terraform
terraform init -backend-config=env/backend.tfvars
terraform plan -var-file env/project.tfvars
terraform apply -var-file env/project.tfvars
terraform destroy -var-file env/project.tfvars

# Bootstrap (first-time GCP project setup)
export TF_VAR_tbd_semester=2026L
export TF_VAR_user_id=9991
export TF_VAR_billing_account=01DEC6-435BA6-84FE33
export GOOGLE_BILLING_PROJECT=$(echo "tbd-${TF_VAR_tbd_semester}-${TF_VAR_user_id}" | tr '[:upper:]' '[:lower:]')
cd bootstrap && terraform init && terraform apply && cd ..

# CI/CD bootstrap (Workload Identity Federation setup)
gcloud auth configure-docker
cd cicd_bootstrap && terraform init -backend-config=../env/backend.tfvars
terraform apply -var-file ../env/project.tfvars -var-file conf/github_actions.tfvars && cd ..

# Pre-commit hooks (linting & security)
pip install pre-commit   # if not installed
pre-commit install
pre-commit run --all-files

# Airflow on GKE — connect to cluster & access UI
gcloud container clusters get-credentials airflow-cluster --zone europe-west1-b --project PROJECT_NAME
kubectl port-forward svc/airflow-webserver 8080:8080 -n airflow

# Submit Spark job directly to Dataproc
gcloud dataproc jobs submit pyspark gs://PROJECT_NAME-code/spark-job.py \
  --cluster=tbd-cluster --region=europe-west1 --project=PROJECT_NAME
```

## Architecture

The root `main.tf` orchestrates all infrastructure by calling modules:

```
main.tf (root)
├── modules/vpc/          → VPC, subnets, Cloud NAT, firewall rules
├── modules/dataproc/     → Spark cluster, staging/temp GCS buckets, IAM
├── modules/airflow/      → GKE Standard cluster for Airflow (pd-standard disks)
├── modules/data-pipeline/ → Spark jobs, code & data GCS buckets
├── modules/gcr/          → Artifact Registry
├── helm_release "airflow" → Apache Airflow chart (KubernetesExecutor, external PostgreSQL)
└── modules/composer/     → [DISABLED] Cloud Composer — SSD quota too low on student accounts
```

**Bootstrap flow**: `bootstrap/` provisions the GCP project → `cicd_bootstrap/` sets up GitHub Actions WIF → root Terraform deploys all modules.

**Data pipeline flow**: Spark jobs are submitted to Dataproc either via Airflow DAGs on GKE or directly via `gcloud dataproc jobs submit pyspark`.

### Why Composer was replaced with GKE Standard + Helm Airflow

Cloud Composer 2 uses GKE **Autopilot** which allocates ~200+ GB **SSD** disks internally. Student billing accounts have a hard 250 GB SSD quota across ALL regions, which cannot be increased via self-service. After multiple failed attempts (CPU quota, SA permissions, pod health), Composer proved unreliable on student accounts. GKE Standard with `pd-standard` disks avoids SSD quota entirely.

### Airflow Helm deployment notes

The Helm chart (apache-airflow 1.16.0) has known issues that required workarounds:
1. **Bitnami PostgreSQL image tags removed from DockerHub** — the bundled `bitnami/postgresql:16.1.0-debian-11-r15` no longer exists. Workaround: deploy standalone PostgreSQL using `postgres:16-alpine` and set `postgresql.enabled=false` in Helm values.
2. **PGDATA mount point** — PVC mounted directly to `/var/lib/postgresql/data` contains `lost+found`. Fix: set `PGDATA=/var/lib/postgresql/data/pgdata`.
3. **DB migration job** — with `--no-hooks`, the migration job doesn't run. Must manually create a Job running `airflow db migrate`.
4. **Webserver startup probe** — default startup probe (60s) too short on e2-standard-2. Fix: increase failureThreshold to 12 and periodSeconds to 15 (~180s).
5. **No admin user created** — with `--no-hooks`, the create-user job doesn't run. Must manually create: `kubectl exec -n airflow <webserver-pod> -- airflow users create --username admin --password admin --firstname Admin --lastname User --role Admin --email admin@example.com`.
6. **KubernetesExecutor does NOT work for this workshop** — task pods start with empty `/opt/airflow/dags/` so they can't find the DAG. Must use **LocalExecutor** instead (scheduler executes tasks in-process).
7. **`google_cloud_default` connection must be created** — DataprocSubmitJobOperator requires it. Create via: `airflow connections add google_cloud_default --conn-type google_cloud_platform --conn-extra '{"project": "PROJECT_NAME"}'`.
8. **Airflow variables must be set** — DAG uses `{{ var.value.xxx }}` templates. Set via: `airflow variables set project_id PROJECT_NAME`, `airflow variables set region_name europe-west1`, `airflow variables set bucket_name PROJECT_NAME-code`, `airflow variables set phs_cluster tbd-cluster`.
9. **DAG files must be copied to scheduler AND webserver pods** — no git-sync or shared volume configured. Use `kubectl cp` to both pods after each change.

## CI/CD Workflows (`.github/workflows/`)

- **pull-request.yml**: Runs hadolint, terraform fmt/validate/plan, checkov, infracost on PRs
- **release.yml**: On merge to master — semantic-release, terraform apply (auto-approve)
- **build-push-image.yml**: Builds/pushes dev Docker image on changes to `devel/docker/`
- **destroy.yml**: Tears down infrastructure (manual trigger)

## Key Configuration Files

- `.checkov.yaml` — Security scanner skip rules (relaxed for workshop context)
- `.hadolint.yaml` — Dockerfile linting config
- `.pre-commit-config.yaml` — Pre-commit hooks (terraform checks, hadolint)
- `.releaserc` — Semantic release with angular commit convention
- `variables.tf` — Input variables: `project_name` and `region`
- `backend.tf` — Terraform remote state in GCS

## Conventions

- Commits follow Angular convention (feat:, fix:, etc.) for semantic-release
- Terraform modules are self-contained under `modules/` with standard `main.tf`, `variables.tf`, `outputs.tf`
- Spark jobs live in `modules/data-pipeline/resources/`
- Notebooks in `notebooks/` are for student exercises (TPC-DI setup, MLOps, Spark)

## Proposed Task Modifications (tasks-phase1.md)

### Tasks 9 and 10 — swap order, make more educational

Original tasks are too simple (task 10: "find the error" — just read code) and in wrong order (task 9 needs ORC data from task 10). Proposed replacement:

**10. Run the Spark job via Airflow and fix the error**

> a) In the Airflow UI, find the `dataproc_job` DAG, unpause it and trigger it manually.
>
> ***place a screenshot of the DAG in the Airflow UI***
>
> b) The DAG will fail. Examine the task logs in Airflow UI to find the root cause.
>
> ***paste the relevant error message from the Airflow task log***
>
> ***describe what the error is and how you found it***
>
> c) Fix the error in `modules/data-pipeline/resources/spark-job.py`, re-upload the file to GCS and trigger the DAG again.
>
> ***paste the link to the fixed file***
>
> d) Verify the DAG completes successfully and check that ORC files were written to the data bucket:
> ```bash
> gsutil ls gs://PROJECT_NAME-data/data/shakespeare/
> ```
>
> ***place a screenshot of the successful DAG run in Airflow UI***

**9. Create a BigQuery dataset and an external table**

> Using the ORC data produced by the Spark job in task 10, create a BigQuery dataset and an external table using SQL.
>
> ***place the SQL code and query output here***
>
> ***why does ORC not require a table schema definition?***

This flow is more educational: students learn to debug in Airflow (reading task logs, understanding job submission) rather than just reading source code.

## Known Issues in Workshop Instructions (tasks-phase1.md)

1. **README step numbering**: Steps go 0,1,2,3,4,6,6,7 — skips step 5, duplicates step 6.
2. **`ai_notebook_instance_owner` in `env/project.tfvars`**: Variable defined there but commented out in root `variables.tf` — causes terraform warning about unknown variable.
3. **Google provider version mismatch**: `bootstrap/provider.tf` uses `~> 6.26.0`, root `provider.tf` uses `~> 5.44.0`.
4. **Task 8 (Infracost)**: Wrong resource type names — should be `google_artifact_registry_repository` (not `google_artifact_registry`). `google_service_networking_connection` only exists in `mlops/` which is not deployed by students.
5. **Tasks 9 and 10 wrong order**: Task 9 (BigQuery external table over ORC) requires data from spark-job.py, but task 10 (fix spark-job.py hardcoded bucket) must be done first.
6. **Task 10 (spark-job.py)**: Error is hardcoded `DATA_BUCKET = "gs://tbd-2025z-9901-data/data/shakespeare/"` — trivial to spot by reading code.
7. **Task 6 (YARN UI)**: Cluster has `internal_ip_only = true` so IAP tunnel is required, but no hints given.
8. **Task 3**: References "main branch" but repo uses "master".
9. **Task 12 (auto-destroy)**: No hint that students can base it on existing `destroy.yml`.
10. **`iac_service_account` in `env/project.tfvars`**: Not declared in root `variables.tf` — causes terraform warning on every plan/apply.

## Undocumented Steps Required During Setup

Steps that were necessary but not mentioned in README.md:

1. **Terraform version**: README requires `~> 1.11.0` but doesn't explain how to install it. Students with other versions will fail at `terraform init`.
2. **`GOOGLE_BILLING_PROJECT` env var**: Bootstrap `terraform apply` fails on budget creation with `Error 403: billingbudgets.googleapis.com API requires a quota project`. README mentions this variable in step 1 but doesn't explain it's **required** for bootstrap apply to succeed.
3. **`pre-commit` not installed**: README says `pre-commit install` but doesn't mention `pip install pre-commit` first.
4. **`ai_notebook_instance_owner` removal**: Must be removed from `env/project.tfvars` — no longer declared in root `variables.tf`.
5. **`iac_service_account` warning**: This variable in `project.tfvars` is only used by `cicd_bootstrap`, not by root terraform. Harmless but confusing.
6. **`gcloud auth configure-docker`**: Needed before cicd_bootstrap apply — easy to miss.
7. **GitHub Secrets manual setup**: Students need to navigate GitHub UI to set `GCP_WORKLOAD_IDENTITY_PROVIDER_NAME`, `GCP_WORKLOAD_IDENTITY_SA_EMAIL`, and `INFRACOST_API_KEY`.
8. **Transient network errors**: Both `terraform init` and `terraform apply` can fail with `dial tcp ... connect: network is unreachable`. Retry fixes it.
9. **CRITICAL — CPU quota too low**: Default `CPUS_ALL_REGIONS` is **12 vCPU**. Dataproc (6) + GKE Airflow (4) = 10+ vCPU needed. Students should request increase to 24+ via GCP Console (IAM & Admin > Quotas) **before** root terraform apply.
10. **Cloud Services SA missing `roles/editor`**: GKE/Composer creation may fail. Fix: `gcloud projects add-iam-policy-binding PROJECT_ID --member="serviceAccount:PROJECT_NUMBER@cloudservices.gserviceaccount.com" --role="roles/editor"`.
11. **Composer 2 does NOT work on student billing accounts**: 250 GB SSD quota (hard limit, all regions) is too low for Composer 2 Autopilot. This is why the workshop was migrated to GKE Standard + Helm Airflow.
