IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   Grupa 10

   https://github.com/iotchenkoarist/tbd-workshop-1
   
2. Follow all steps in README.md.

3. Select your project and set budget alerts on 5%, 25%, 50%, 80% of 50$ (in cloud console -> billing -> budget & alerts -> create buget; unclick discounts and promotions&others while creating budget).

  ![img.png](doc/figures/discounts.png)

4. From avaialble Github Actions select and run destroy on main branch.


  ![img.png](doc/figures/destroy_resources.png)
   
5. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    
      ![img.png](doc/figures/release.png)


6. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***
   
7. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   
8. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    ![img.png](doc/figures/vpc.png)
    2. Description of the components of service accounts
       * tbd-2024l-308908-lab@tbd-2024l-308908.iam.gserviceaccount.com (tbd-terraform) - handles Terraform-related
       activities, allows infrastructure management of Google Cloud project from terraform level
       * tbd-2024l-308908-data@tbd-2024l-308908.iam.gserviceaccount.com (tbd-composer-sa) - manages the
       Cloud Composer environment, including the orchestration of Dataproc clusters and various jobs within
       that environment
       * 973102651483-compute@developer.gserviceaccount.com (iac) - mediator between GitHub and
       Google Cloud services, manages distribution of access tokens
    3. List of buckets for disposal
       * tbd-2024l-308908-code - Apache Spark job file
       * tbd-2024l-308908-conf - Notebook post startup script file
       * tbd-2024l-308908-data - Files with data from data-pipelines
       * tbd-2024l-308908-state - Terraform state files
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
       * 10.10.10.2: tbd-cluster-w-1 - Worker
       * 10.10.10.3: tbd-cluster-w-0 - Worker
       * 10.10.10.4: tbd-cluster-m - Master
       * 10.10.10.5: tbd-2024-308908-notebook - JupyterLab Notebook VM

       In the context of Vertex AI Workbench, the Spark driver may run on a different machine or container than the Spark cluster itself.
       By specifying the host for the driver, we ensure that the Spark driver knows where to send tasks for execution and where to collect results from the Spark cluster.
       This information is crucial for establishing communication channels between the driver and the cluster, enabling efficient data processing and computation.
       * driver port: 30000
       * block manager: 30001

    ***place your diagram here***

11. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ***place the expected consumption you entered here***

   ***place the screenshot from infracost output here***

11. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***

  
12. Start an interactive session from Vertex AI workbench:

    ![img.png](doc/figures/vertexAI.png)
   
13. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

14. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place the link to the modified file and inserted terraform code***
    
    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    ***place the link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place the link to the modified file and inserted terraform code***
