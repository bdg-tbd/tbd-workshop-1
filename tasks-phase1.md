IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   Z3

   https://github.com/helacel/tbd-workshop-1-Z3.git
   
2. Follow all steps in README.md.

3. From avaialble Github Actions select and run destroy on main branch.
   
4. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release.
  
    Niestety nie wyszedł realase...

    <img width="2118" height="1079" alt="image" src="https://github.com/user-attachments/assets/4a04297f-9c0f-485d-bdd7-0ed40e8d8e1a" />



5. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

.../tbd-workshop-1-Z3$ terraform graph > graph.dot
.../tbd-workshop-1-Z3$ less graph.dot
szukamy: /module.dataproc

    subgraph "cluster_module.dataproc" {
    label = "module.dataproc"
    fontname = "sans-serif"
    "module.dataproc.google_dataproc_cluster.tbd-dataproc-cluster" [label="google_dataproc_cluster.tbd-dataproc-cluster"];
    "module.dataproc.google_project_iam_member.dataproc_bigquery_data_editor" [label="google_project_iam_member.dataproc_bigquery_data_editor"];
    "module.dataproc.google_project_iam_member.dataproc_bigquery_user" [label="google_project_iam_member.dataproc_bigquery_user"];
    "module.dataproc.google_project_iam_member.dataproc_worker" [label="google_project_iam_member.dataproc_worker"];
    "module.dataproc.google_project_service.dataproc" [label="google_project_service.dataproc"];
    "module.dataproc.google_service_account.dataproc_sa" [label="google_service_account.dataproc_sa"];
    "module.dataproc.google_storage_bucket.dataproc_staging" [label="google_storage_bucket.dataproc_staging"];
    "module.dataproc.google_storage_bucket.dataproc_temp" [label="google_storage_bucket.dataproc_temp"];
    "module.dataproc.google_storage_bucket_iam_member.staging_bucket_iam" [label="google_storage_bucket_iam_member.staging_bucket_iam"];
    "module.dataproc.google_storage_bucket_iam_member.temp_bucket_iam" [label="google_storage_bucket_iam_member.temp_bucket_iam"];
  }
   
6. Reach YARN UI
   
   Polecenie do ustawienia tunelu SSH:

gcloud compute ssh tbd-cluster-m \
  --project=tbd-2025z-2137 \
  --zone=europe-west1-b \
  --tunnel-through-iap \
  -- -L 8088:localhost:8088

Port lokalny: 8088

YARN UI dostępne pod adresem:
http://localhost:8088

<img width="2879" height="1696" alt="Zrzut ekranu 2025-11-24 210432" src="https://github.com/user-attachments/assets/804e368c-da98-440b-baf6-bcb5a2169ac4" />

   
7. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. Description of the components of service accounts
    2. List of buckets for disposal
    
    ***place your diagram here***

8. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

resource_type_default_usage:
  google_artifact_registry_repository:
    storage_gb: 10
    monthly_egress_data_transfer_gb:
      europe_west1: 20

  google_storage_bucket:
    storage_gb: 50
    monthly_class_a_operations: 20000
    monthly_class_b_operations: 100000
    monthly_data_retrieval_gb: 50
    monthly_egress_data_transfer_gb:
      same_continent: 40

  google_service_networking_connection:
    monthly_egress_data_transfer_gb:
      same_region: 100
      europe: 50
      
<img width="1854" height="1317" alt="image" src="https://github.com/user-attachments/assets/26de57dd-b5fd-4ce0-9e13-e9444bb50475" />

9. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***

10. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

11. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
12. Triggered Terraform Destroy on Schedule or After PR Merge. Goal: make sure we never forget to clean up resources and burn money.

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
