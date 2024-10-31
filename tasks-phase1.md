IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

**z12**

*Jan Budziński*  
*Marcin Godniak*  
*Kacper Klassa*  

**https://github.com/kklassa/tbd-workshop-1-24z-z12**
   
2. Follow all steps in README.md.

3. Select your project and set budget alerts on 5%, 25%, 50%, 80% of 50$ (in cloud console -> billing -> budget & alerts -> create buget; unclick discounts and promotions&others while creating budget).

  ![img.png](doc/figures/discounts.png)

5. From avaialble Github Actions select and run destroy on main branch.
   
7. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    
    ![Successful application of release workflow](doc/figures/ga-release-workflow-success.png)


8. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    **Data Pipeline module**:

    This module is responsible for creating and configuring Google Cloud Storage buckets which are used for
    storing scripts that are utilized by the data pipeline based on Apache Airflow. Two buckets are created 
    by the module - one is storing code for a Spark job (`tbd-code-bucket`) and the other is for storing 
    pipeline data (`tbd-data-bucket`). Resources responsible for IAM bindings to those buckets for service 
    accounts are also configured and provisioned, as well as a GCS bucket object for the code bucket.

    The following diagram presents the dependencies between resources created by the module:

    ![Terrafrom Graph output for Data Pipeline module](doc/figures/data-pipeline-graph.png)

    Interestingly not all resources of type `google_storage_bucket_object` are connected to a `google_storage_bucket` resource. That is because the `dag-code` and `dbt-dag-code` bucket objects are a part of a diffreent bucket that is provisioned by [`composer`](modules/composer/) module. These bucket objects contain scripts with DAGs for Apache Airflow.


   
9. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   
10. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
  
    ***place your diagram here***

11. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ***place the expected consumption you entered here***

   ***place the screenshot from infracost output here***

11. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
    ``` sql
    CREATE SCHEMA IF NOT EXISTS task1;

    CREATE EXTERNAL TABLE task1.2015_flights
    OPTIONS (
      format = 'parquet',
      uris = ['gs://bucket-tbd-z12/2015_flights.parquet']
    );
    ```
    ![image](https://github.com/user-attachments/assets/5ed43a3c-eb4e-4317-8a95-3b33453e597e)

    ***why does ORC not require a table schema?***

  
13. Start an interactive session from Vertex AI workbench:

    ***place the screenshot of notebook here***
   
14. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

15. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place the link to the modified file and inserted terraform code***
    
    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    ***place the link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place the link to the modified file and inserted terraform code***
