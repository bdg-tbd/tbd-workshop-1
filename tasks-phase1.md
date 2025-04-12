IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   **GR15**

   **https://github.com/hpogorze/tbd-workshop-1**
   
2. Follow all steps in README.md.

3. In boostrap/variables.tf add your emails to variable "budget_channels".

4. From avaialble Github Actions select and run destroy on main branch.
   ![image](https://github.com/user-attachments/assets/d851c467-58ff-438e-ac57-6df376207eb1)

5. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    ![image](https://github.com/user-attachments/assets/d5c7af96-92db-460a-8383-669434f194be)

    ***place the screenshot from GA after succesfull application of release***


6. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.
![image](https://github.com/user-attachments/assets/edc06c53-cab4-46ed-ad0c-e99e2fdd8cea)


This Terraform module provisions a Google Cloud Composer environment, which is a fully managed workflow orchestration service built on Apache Airflow. The module automates the setup of the Composer environment and its required dependencies, such as service accounts, IAM bindings, APIs, and subnetworks.
The Composer environment (google_composer_environment.composer_env) is the core resource of this module. It depends on a custom subnetwork (google_compute_subnetwork.composer-subnet) and several IAM roles that allow the environment to operate correctly. These include roles for the Composer agent (google_project_iam_member.composer_agent_service_account), and various project-level permissions for Dataproc and other GCP services.
The module also creates a service account (google_service_account.tbd-composer-sa) that is granted permissions to manage Composer and Dataproc resources, and ensures the Composer and Dataproc APIs are enabled through the google_project_service.api resource.
By using this module, users can quickly deploy a production-ready Apache Airflow environment in Google Cloud with minimal manual configuration. This is ideal for managing ETL pipelines, scheduled workflows, and task orchestration across cloud services.
   
7. Reach YARN UI
 ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   ![image](https://github.com/user-attachments/assets/528e56c5-b7e1-490c-8109-43c951841991)
![image](https://github.com/user-attachments/assets/d387b6d6-9ec3-4a96-a4ad-c942cc2aaf70)

8. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
       
       The project includes several service accounts, each serving a specific purpose. The tbd-terraform service account is responsible for managing infrastructure using Terraform and has permissions to provision and update cloud resources. The iac service account is used for Infrastructure as Code automation, particularly for CI/CD pipelines and GitHub integration. It ensures that infrastructure changes are applied consistently from version-controlled configurations. The tbd-composer-sa service account is associated with Cloud Composer and is used to manage and execute Airflow DAGs, access storage buckets, and communicate with Dataproc and Vertex AI. These accounts follow the principle of least privilege and are scoped for their respective roles.
       
    3. List of buckets for disposal
       
       The following Google Cloud Storage buckets were created during the project. The tbd-2025l-9923-code bucket contains source code, Python scripts, and Spark libraries. The tbd-2025l-9923-data bucket holds datasets used in Spark jobs and Composer pipelines. The tbd-2025l-9923-conf bucket includes configuration files and startup scripts. The tbd-2025l-9923-state bucket is used to store the Terraform backend state, which tracks the deployed infrastructure. These buckets are essential for organizing resources and enabling reproducible deployments
       
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
       
  Apache Spark jobs launched from Vertex AI Workbench rely on direct communication between the driver and executors. The driver, running on the notebook instance, must expose a reachable IP and port so that the worker nodes can connect back. In this project, the driver runs on port 30000. The Spark master node typically listens on port 7077 to manage cluster resources. Worker nodes use dynamic ports in the range 49152 to 65535 to handle task execution and data transfer. Specifying the driver host explicitly is required to ensure that network routes are correctly resolved within the VPC and that firewall rules allow traffic between the driver and workers. This configuration ensures reliable job coordination and execution in a distributed environment.

  ![image](https://github.com/user-attachments/assets/18f05f32-005c-4d0e-aed3-e4e307f16e79)

   

9. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ![image](https://github.com/user-attachments/assets/812fcdeb-2421-4c25-a5fc-e8f414d08d75)
![image](https://github.com/user-attachments/assets/73659779-2a6f-4a61-bafc-7fef4c0099a4)

![image](https://github.com/user-attachments/assets/3fc3acec-de3d-45d9-8bd8-a09a9eda61f1)

10. Create a BigQuery dataset and an external table using SQL
    ![image](https://github.com/user-attachments/assets/1b1b4282-c937-4721-8a35-093c192fc3f2)

  ![image](https://github.com/user-attachments/assets/56746766-8402-45d1-86db-f877694ddd20)

  ORC files don’t need a predefined table schema because they embed structural metadata directly within the file. This includes column names, data types, and other relevant schema details. As a result, platforms like BigQuery can automatically detect the structure of the data when creating external tables. This self-describing nature of ORC simplifies data loading and reduces human error. Compared to flat formats like CSV, where the schema has to be manually defined, ORC is much more convenient and efficient — especially when working with complex or evolving datasets.

11. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***
    The issue was caused by specifying an incorrect path to the Cloud Storage bucket. When running the Spark job on the Dataproc cluster, an error occurred due to the system being unable to locate or access the expected file. This error was clearly identifiable through the logs available in the Google Cloud Console. After reviewing the logs, I corrected the path to point to the appropriate bucket within the project, which resolved the issue.
![image](https://github.com/user-attachments/assets/1afc5784-453b-4696-aecf-d7974858ae4f)
![image](https://github.com/user-attachments/assets/fd853ed3-bb76-480d-a0f2-643966c120c2)


12. Add support for preemptible/spot instances in a Dataproc cluster
![image](https://github.com/user-attachments/assets/f7f9bcab-68ec-4d60-b3b3-8ab3c8a79359)
![image](https://github.com/user-attachments/assets/1984f661-966a-42a2-bf4a-c667d311d9a2)

    ***place the link to the modified file and inserted terraform code***
    
    
