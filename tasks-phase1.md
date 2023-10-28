1. Authors:

   ***your group nr***

   ***link to forked repo***
   
2. Follow all steps in README.md.
3. From avaialble Github Actions select and run destroy on main branch.
4. Create new git branch and two resources in ```/modules/data-pipeline/main.tf```:
    1. resource "google_storage_bucket" "tbd-data-bucket" -> the bucket to store data. Set the following properties:
        * project  // look for variable in variables.tf
        * name  // look for variable in variables.tf
        * location // look for variable in variables.tf
        * uniform_bucket_level_access = false #tfsec:ignore:google-storage-enable-ubla
        * force_destroy               = true
        * public_access_prevention    = "enforced"
        * if checkcov returns error, add other properties if needed
       
    2. resource "google_storage_bucket_iam_member" "tbd-data-bucket-iam-editor" -> assign role storage.objectUser to data service account. Set the following properties:
        * bucket // refere to bucket name from tbd-data-bucket
        * role   // follow the instruction above
        * member = "serviceAccount:${var.data_service_account}"

    ***place the terraform snippet here***

    Create PR from this branch to **YOUR** master and merge it to make new release. 
    
    ***place the screenshot from GA after succesfull application of release with this changes***

    

5. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***
   
6. Reach YARN UI
   
   ***place port  and the screenshot of YARN UI here***
   
7. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
  
    ***place diagram here***

8. Add costs by entering the expected consumption into Infracost

   ***place the expected consuption you entered here***

   ***place the screenshot from infracost output here***

9. Create a BigQuery dataset and an external table
    
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***
  
10. Start an interactive session from Vertex AI workbench:

    ***place the screenshot of notebook here***
   
11. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

12. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place link to the modified file and inserted terraform code***
    
    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place link to the modified file and inserted terraform code***
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    ***place link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place link to the modified file and inserted terraform code***
