IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

    ***group 8:***
    wojciech.dzikon.stud@pw.edu.pl
    radoslaw.kasprzak.stud@pw.edu.pl
    karol.ostrowski.stud@pw.edu.pl
    

    ***https://github.com/RadoslawKasprzak/tbd-workshop-1***
   
3. Follow all steps in README.md.

4. Select your project and set budget alerts on 5%, 25%, 50%, 80% of 50$ (in cloud console -> billing -> budget & alerts -> create buget; unclick discounts and promotions&others while creating budget).

  ![img.png](doc/figures/discounts.png)

5. From avaialble Github Actions select and run destroy on main branch.
   
7. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    
    ***place the screenshot from GA after succesfull application of release***
  ![image](https://github.com/user-attachments/assets/cf176125-9331-4903-87bc-a5a20bbc6076)


8. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***

   
10. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   ![image](https://github.com/user-attachments/assets/b5782c61-f1e8-47a9-a2e2-221e58c86e34)
   We set up a SSH tunneling via IAP to port 8088 in dataproc cluster -m in through local port 8088.

   
11. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
  
    ***place your diagram here***

12. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   As we only have 'google_storage_bucket' type existing in code we will procide:
 <!-- ./.terraform/modules/composer.composer/examples/simple_composer_env_v2/main.tf:resource "google_storage_bucket" "my_bucket" {
./bootstrap/main.tf:resource "google_storage_bucket" "tbd-state-bucket" {
./mlops/mlflow/gcp/app_engine/storage.tf:resource "google_storage_bucket" "mlflow_artifacts_bucket" {
./modules/data-pipeline/main.tf:resource "google_storage_bucket" "tbd-code-bucket" {
./modules/data-pipeline/main.tf:resource "google_storage_bucket" "tbd-data-bucket" {
./modules/vertex-ai-workbench/main.tf:resource "google_storage_bucket" "notebook-conf-bucket" { -->


   ***place the expected consumption you entered here***
    Expected consumption saved in infracost-usage.yml

    
   ***place the screenshot from infracost output here***
   ![alt text](expected_costs.png)

11. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
   
    ***why does ORC not require a table schema?***

  
12. Start an interactive session from Vertex AI workbench:

    ***place the screenshot of notebook here***
    ![image](https://github.com/user-attachments/assets/7ccb780a-6fd7-4e2a-a744-11e33e1df83f)

   
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
