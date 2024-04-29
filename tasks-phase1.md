IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   Zespół 11
   - Mateusz Winnicki
   - Bartosz Sweklej
   - Magdalena Lutyńska

   [link to forked repo](https://github.com/batmatt/tbd-workshop-1)
   
2. Follow all steps in README.md.

3. Select your project and set budget alerts on 5%, 25%, 50%, 80% of 50$ (in cloud console -> billing -> budget & alerts -> create buget; unclick discounts and promotions&others while creating budget).

  ![img.png](doc/figures/discounts.png)
  ![img.png](doc/figures/zad3.webp)

5. From avaialble Github Actions select and run destroy on main branch.
   
7. Create new git branch and:
    1. Modify tasks-phase1.md file.
    
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    
    ***place the screenshot from GA after succesfull application of release***
   ![img.png](doc/figures/zad6.webp)


9. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***
   - bootstrap/main.tf:
     ![img.png](doc/figures/bootstrap-graph.png)

   - grc/main.tf:
     ![img.png](doc/figures/gcr-graph.png)
   
11. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
    ![img.png](doc/figures/yarn_ui.png)
    Zestawienia tunelu:
    ```
    gcloud compute ssh tbd-cluster-m \
      --project=tbd-2024l-300524 \
      --zone=europe-west1-d -- -D 1080 -N
    ```
    Dostęp do YARN UI przez proxy na lokalnej przeglądarce:
    ```
    /usr/bin/google-chrome \
    --proxy-server="socks5://localhost:1080" \
    --user-data-dir="/tmp/tbd-cluster-m" http://tbd-cluster-m:8088
    ```
    
    
11. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
  
    ***place your diagram here***

12. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   ***place the expected consumption you entered here***
   ```version: 0.1
resource_usage:
  google_artifact_registry_repository.registry:
    storage_gb: 150
    monthly_egress_data_transfer_gb:
      europe_west1: 100
      us_central1: 50
      asia_east1: 30

  google_storage_bucket.tbd-state-bucket:
    storage_gb: 150
    monthly_class_a_operations: 40000
    monthly_class_b_operations: 20000
    monthly_data_retrieval_gb: 500
    monthly_egress_data_transfer_gb:
      same_continent: 550
      worldwide: 12500
      asia: 1500
      china: 50
      australia: 250

  google_storage_bucket.tbd-code-bucket:
    storage_gb: 200
    monthly_class_a_operations: 50000
    monthly_class_b_operations: 25000
    monthly_data_retrieval_gb: 750
    monthly_egress_data_transfer_gb:
      same_continent: 600
      worldwide: 13000
      asia: 1600
      china: 100
      australia: 300

  google_storage_bucket.tbd-data-bucket:
    storage_gb: 250
    monthly_class_a_operations: 45000
    monthly_class_b_operations: 30000
    monthly_data_retrieval_gb: 1000
    monthly_egress_data_transfer_gb:
      same_continent: 500
      worldwide: 12000
      asia: 1400
      china: 75
      australia: 275

  google_storage_bucket.notebook-conf-bucket:
    storage_gb: 180
    monthly_class_a_operations: 42000
    monthly_class_b_operations: 22000
    monthly_data_retrieval_gb: 550
    monthly_egress_data_transfer_gb:
      same_continent: 580
      worldwide: 12300
      asia: 1550
      china: 60
      australia: 260

  google_storage_bucket.mlflow_artifacts_bucket:
    storage_gb: 160
    monthly_class_a_operations: 38000
    monthly_class_b_operations: 21000
    monthly_data_retrieval_gb: 600
    monthly_egress_data_transfer_gb:
      same_continent: 560
      worldwide: 12700
      asia: 1500
      china: 55
      australia: 245

  google_service_networking_connection.private_vpc_connection:
    monthly_egress_data_transfer_gb:
      same_region: 250
      us_or_canada: 100
      europe: 70
      asia: 50
      south_america: 100
      oceania: 50
      worldwide: 200
```

   ***place the screenshot from infracost output here***
   Wynik estymacji Infracosta na PR dodającym Infracost (brak zmian w infrastrukturze)
   ![obraz](https://github.com/batmatt/tbd-workshop-1/assets/62250240/80dc5507-e19d-4825-98db-7668da4c5389)

   Wynik estymacji Infracosta na PR dodającym przykładowy plik testowy wprowadzjący zmiany w infrastrukturze: https://github.com/infracost/example-terraform/blob/master/google/main.tf
  ![obraz](https://github.com/batmatt/tbd-workshop-1/assets/62250240/00ba7b9a-8b1e-4b1d-aba4-0de936e3f094)
   
11. Create a BigQuery dataset and an external table using SQL
    
    ***place the code and output here***
    ```
    CREATE SCHEMA IF NOT EXISTS demo OPTIONS(location = 'europe-west1');
    CREATE OR REPLACE EXTERNAL TABLE `tbd-2024l-300524.demo.shakespeare` OPTIONS ( format = 'ORC', uris = ['gs://tbd-2024l-300524-data/*.orc']);
    SELECT * FROM demo.shakespeare ORDER BY int1 DESC LIMIT 10;
    ```
     ![img.png](doc/figures/query.webp)
   
    ***why does ORC not require a table schema?***

    
   

  
13. Start an interactive session from Vertex AI workbench:

    ***place the screenshot of notebook here***
   ![img.png](doc/figures/error.webp)
   
15. Find and correct the error in spark-job.py

    ***describe the cause and how to find the error***

16. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    ***place the link to the modified file and inserted terraform code***
    
    3. Add support for preemptible/spot instances in a Dataproc cluster

    ***place the link to the modified file and inserted terraform code***
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    ***place the link to the modified file and inserted terraform code***

    4. (Optional) Get access to Apache Spark WebUI

    ***place the link to the modified file and inserted terraform code***
