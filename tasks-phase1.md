IMPORTANT ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   ***Group nr: 12***

   ***[Link to forked repo](https://github.com/kubaurban/tbd-workshop)***
   
2. Follow all steps in README.md.

3. From avaialble Github Actions select and run destroy on main branch.
   
4. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    
    ![Successful release](images/release.png)


5. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    We analyzed the **dataproc** module, which is responsible for creating a Dataproc cluster.

    The root *main.tf* indicates that this module depends on a VPC module. Indeed, it takes the subnet value as input, which is an output of the VPC module creation. The module output is a newly created Dataproc cluster name.

    Using the following Terraform command, we created a plan file named *dataproc_plan.tfplan*:

    ```sh
    terraform plan -target=module.dataproc -var-file=env/project.tfvars -out=dataproc_plan.tfplan -input=false -compact-warnings
    ```

    After converting this plan file into a JSON file, we discovered that the module contains multiple resources, including IAM role assignments (e.g., *bigquery_data_editor*, *bigquery_user*, etc.), a Dataproc service account, GCS buckets, and the Dataproc cluster itself.

    We also generated a dependency diagram of this module using terraform graph within the module folder:

    ```dot
    digraph G {
        rankdir = "RL";
        node [shape = rect, fontname = "sans-serif"];
        "google_dataproc_cluster.tbd-dataproc-cluster" [label="google_dataproc_cluster.tbd-dataproc-cluster"];
        "google_project_iam_member.dataproc_bigquery_data_editor" [label="google_project_iam_member.dataproc_bigquery_data_editor"];
        "google_project_iam_member.dataproc_bigquery_user" [label="google_project_iam_member.dataproc_bigquery_user"];
        "google_project_iam_member.dataproc_worker" [label="google_project_iam_member.dataproc_worker"];
        "google_project_service.dataproc" [label="google_project_service.dataproc"];
        "google_service_account.dataproc_sa" [label="google_service_account.dataproc_sa"];
        "google_storage_bucket.dataproc_staging" [label="google_storage_bucket.dataproc_staging"];
        "google_storage_bucket.dataproc_temp" [label="google_storage_bucket.dataproc_temp"];
        "google_storage_bucket_iam_member.staging_bucket_iam" [label="google_storage_bucket_iam_member.staging_bucket_iam"];
        "google_storage_bucket_iam_member.temp_bucket_iam" [label="google_storage_bucket_iam_member.temp_bucket_iam"];
        "google_dataproc_cluster.tbd-dataproc-cluster" -> "google_project_iam_member.dataproc_bigquery_data_editor";
        "google_dataproc_cluster.tbd-dataproc-cluster" -> "google_project_iam_member.dataproc_bigquery_user";
        "google_dataproc_cluster.tbd-dataproc-cluster" -> "google_project_iam_member.dataproc_worker";
        "google_dataproc_cluster.tbd-dataproc-cluster" -> "google_project_service.dataproc";
        "google_dataproc_cluster.tbd-dataproc-cluster" -> "google_storage_bucket_iam_member.staging_bucket_iam";
        "google_dataproc_cluster.tbd-dataproc-cluster" -> "google_storage_bucket_iam_member.temp_bucket_iam";
        "google_project_iam_member.dataproc_bigquery_data_editor" -> "google_service_account.dataproc_sa";
        "google_project_iam_member.dataproc_bigquery_user" -> "google_service_account.dataproc_sa";
        "google_project_iam_member.dataproc_worker" -> "google_service_account.dataproc_sa";
        "google_storage_bucket_iam_member.staging_bucket_iam" -> "google_service_account.dataproc_sa";
        "google_storage_bucket_iam_member.staging_bucket_iam" -> "google_storage_bucket.dataproc_staging";
        "google_storage_bucket_iam_member.temp_bucket_iam" -> "google_service_account.dataproc_sa";
        "google_storage_bucket_iam_member.temp_bucket_iam" -> "google_storage_bucket.dataproc_temp";
    }
    ```

    ![Dataproc graph](images/dataproc.png)

   
6. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   
7. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. Description of the components of service accounts
    2. List of buckets for disposal

    Based on diagram generated for solution with terraform graph we created leaner diagram presenting solution modular architecture. The following diagram includes service accounts (blue colored) linked to IAM roles and disposable buckets (yellow colored). We omitted service accounts (visible on diagram) created implicitly - we highlighted only those specified explicitly in terraform code.
    
    ![Diagram](<images/graphviz.svg>)

8. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ***place the expected consumption you entered here***

   ***place the screenshot from infracost output here***

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
