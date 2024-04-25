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
    ![terraform graph](terraform_graph.jpeg)
    Provider Node:

    The provider["registry.terraform.io/hashicorp/google"] is the Google Cloud provider used by Terraform to manage GCP resources.


    Resource Nodes:

    - google_dataproc_metastore_service.demo: Represents a Google Dataproc Metastore service resource to be managed by Terraform. It's shaped like a box, indicating it's a standard resource.
    - google_project_service.api-metastore: Represents enabling of the Metastore API service for the GCP project, also shaped like a box.

    Variable Nodes:

    - var.metastore_version, var.network, var.project_name, and var.region are variables that provide configurable parameters to Terraform resources. They are shaped like notes, indicating that they are input variables.

    Output Node:

    - output.metastore_name: An output that will display the metastore service's name after the resources are applied.

    Edges (Dependencies):

    - An edge from google_dataproc_metastore_service.demo to google_project_service.api-metastore indicates that the Dataproc Metastore service resource depends on the Metastore API service being enabled.
    Edges from google_dataproc_metastore_service.demo to the variable nodes (var.metastore_version, var.network, and var.region) indicate that the creation of this resource depends on these variables.
    - An edge from google_project_service.api-metastore to provider["registry.terraform.io/hashicorp/google"] indicates that enabling the API service depends on the Google provider.
    - An edge from google_project_service.api-metastore to var.project_name shows a dependency on the project name variable for the API service configuration.
    - The output node output.metastore_name depends on the successful creation of google_dataproc_metastore_service.demo.
    - The provider has a lifecycle edge (close) to google_dataproc_metastore_service.demo, indicating a point in the graph where resources managed by the provider may be created or destroyed.

    Root Node:

    - The root node represents the root module in Terraform, which is the entry point of the configuration. It has edges to the output node and the provider node, signaling that it orchestrates their creation and management.

9. Reach YARN UI
   
   Used command: ***gcloud compute ssh --zone "europe-west1-d" "tbd-cluster-m" --tunnel-through-iap --project "tbd-2024l-308908" -- -L 8088:localhost:8088   ***

      ![img.png](doc/figures/yarn.png)
   
8. Draw an architecture diagram (e.g. in draw.io) that includes:
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
   
    ***why does ORC not require a table schema?***

  
12. Start an interactive session from Vertex AI workbench:

    ![img.png](doc/figures/vertexAI.png)
   
13. Find and correct the error in spark-job.py
    Command used: ***gcloud dataproc jobs submit pyspark gs://tbd-2024l-308908-code/spark-job.py --cluster=tbd-cluster --region=europe-west1 --project "tbd-2024l-308908"***
    Logs output:
    ![img.png](doc/figures/spark_error.png)
    Error:
    {
      "code" : 404,
      "errors" : [ {
        "domain" : "global",
        "message" : "The specified bucket does not exist.",
        "reason" : "notFound"
    } ]}

    ***Fix: Change DATA_BUCKET to DATA_BUCKET = "gs://tbd-2024l-308908-data/data/shakespeare/"***
    
    Succesfull output:
    ![img.png](doc/figures/spark_ok.png)
    

14. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place the link to the modified file and inserted terraform code***
    
    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    ***place the link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place the link to the modified file and inserted terraform code***
