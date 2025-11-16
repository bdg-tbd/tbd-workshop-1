IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   group 1

   https://github.com/xcomerni/tbd-workshop-1
   
2. Follow all steps in README.md.

3. From avaialble Github Actions select and run destroy on main branch.
   
4. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    
    ***place the screenshot from GA after succesfull application of release***
   <img width="1081" height="554" alt="image" src="https://github.com/user-attachments/assets/36e6948f-bab1-42e9-82c4-cf6e53c4c5ed" />


6. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***
   The Composer module provisions a fully managed Cloud Composer (Apache Airflow) environment on Google Cloud that enables you to create, schedule, monitor, and manage workflow pipelines (DAGs) with no infrastructure-management overhead. It automatically creates a GKE cluster for Airflow components (schedulers, workers, triggerers), a Cloud SQL database for Airflow metadata, and an environment-specific Cloud Storage bucket that stores DAGs, plugins, logs, and data. The module configures associated service accounts, IAM roles, networking (including VPC/subnet integration and optional Private IP setups), and monitoring/logging integrations. By using this module, you get a production-ready Airflow environment including compute, storage, networking and orchestration, fully managed and integrated into your Google Cloud project.
**variables:**
variable "env_name" {
  type        = string
  description = "Composer env name"
  default     = "demo-lab"
}
variable "project_name" {
  type        = string
  description = "Project name"
}
variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}
variable "network" {
  type        = string
  description = "VPC to use for notebooks"
}
variable "subnet_address" {
  type        = string
  description = "VPC subnet used for deployment"
}
variable "subnet_name" {
  type        = string
  description = "Composer subnet name"
  default     = "composer-subnet-01"
}
variable "image_version" {
  type    = string
  default = "composer-2.11.5-airflow-2.9.3"
}
variable "env_size" {
  type        = string
  description = "Environment size"
  default     = "ENVIRONMENT_SIZE_SMALL"
}
variable "env_variables" {
  type        = map(string)
  description = "Apache Airflow variables to set"
  
**outputs:**
   output "gcs_bucket" {
  description = "GCS bucket for storing Apache Airflow DAGs"
  value       = module.composer.gcs_bucket
}
output "data_service_account" {
  description = "Apache Airflow service account"
  value       = google_service_account.tbd-composer-sa.email
}
output "gke_cluster" {
  description = "Composer underlying GKE cluster"
  value       = module.composer.gke_cluster
}
   
**graph generated from modules/composer:**
   <img width="2436" height="291" alt="composer-graph" src="https://github.com/user-attachments/assets/c3a6a3f0-818b-4d54-a981-c41c89e44db6" />

   
8. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***

gcloud compute ssh tbd-cluster-m \
  --project=tbd-2025z-318326 \
  --zone=europe-west1-d \
  -- -L 8088:localhost:8088

   <img width="1913" height="581" alt="image" src="https://github.com/user-attachments/assets/ae56de32-43c2-4e50-a240-553dbdfb140f" />

   
10. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. Description of the components of service accounts
    2. List of buckets for disposal
    
    ***place your diagram here***

11. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ***place the expected consumption you entered here***

   ***place the screenshot from infracost output here***

11. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***

12. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

13. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
14. Triggered Terraform Destroy on Schedule or After PR Merge. Goal: make sure we never forget to clean up resources and burn money.

Add a new GitHub Actions workflow that:
  1. runs terraform destroy -auto-approve
  2. triggers automatically:
   
   a) on a fixed schedule (e.g. every day at 20:00 UTC)
   
   b) when a PR is merged to main containing [CLEANUP] tag in title

Steps:
  1. Create file .github/workflows/auto-destroy.yml
  2. Configure it to authenticate and destroy Terraform resources
  3. Test the trigger (schedule or cleanup-tagged PR)
     
***paste workflow YAML here***

***paste screenshot/log snippet confirming the auto-destroy ran***

***write one sentence why scheduling cleanup helps in this workshop***
