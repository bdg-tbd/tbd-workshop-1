IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.

![img.png](doc/figures/destroy.png)

0. The goal of this phase is to create infrastructure, perform benchmarking/scalability tests of sample three-tier lakehouse solution and analyze the results using:
* [TPC-DI benchmark](https://www.tpc.org/tpcdi/)
* [dbt - data transformation tool](https://www.getdbt.com/)
* [GCP Composer - managed Apache Airflow](https://cloud.google.com/composer?hl=pl)
* [GCP Dataproc - managed Apache Spark](https://spark.apache.org/)
* [GCP Vertex AI Workbench - managed JupyterLab](https://cloud.google.com/vertex-ai-notebooks?hl=pl)

Worth to read:
* https://docs.getdbt.com/docs/introduction
* https://airflow.apache.org/docs/apache-airflow/stable/index.html
* https://spark.apache.org/docs/latest/api/python/index.html
* https://medium.com/snowflake/loading-the-tpc-di-benchmark-dataset-into-snowflake-96011e2c26cf
* https://www.databricks.com/blog/2023/04/14/how-we-performed-etl-one-billion-records-under-1-delta-live-tables.html

2. Authors:

   ***Group 8***
    - wojciech.dzikon.stud@pw.edu.pl
    - radoslaw.kasprzak.stud@pw.edu.pl
    - karol.ostrowski.stud@pw.edu.pl
   **https://github.com/RadoslawKasprzak/tbd-workshop-1**

3. Sync your repo with https://github.com/bdg-tbd/tbd-workshop-1.

4. Provision your infrastructure.

    a) setup Vertex AI Workbench `pyspark` kernel as described in point [8](https://github.com/bdg-tbd/tbd-workshop-1/tree/v1.0.32#project-setup)
      pyspark kernel installed:
     ![image](https://github.com/user-attachments/assets/08872feb-9f8a-4f2c-9c56-a4ddecc7d1f4)


    b) upload [tpc-di-setup.ipynb](https://github.com/bdg-tbd/tbd-workshop-1/blob/v1.0.36/notebooks/tpc-di-setup.ipynb) to 
the running instance of your Vertex AI Workbench
    script uploaded:
    ![image](https://github.com/user-attachments/assets/95792423-c8c8-44f8-a269-6e5d14410b49)


6. In `tpc-di-setup.ipynb` modify cell under section ***Clone tbd-tpc-di repo***:

   a)first, fork https://github.com/mwiewior/tbd-tpc-di.git to your github organization.

   ![image](https://github.com/user-attachments/assets/aec38e47-ff77-4336-810d-a98e53b51013)


   b)create new branch (e.g. 'notebook') in your fork of tbd-tpc-di and modify profiles.yaml by commenting following lines:
   ```  
        #"spark.driver.port": "30000"
        #"spark.blockManager.port": "30001"
        #"spark.driver.host": "10.11.0.5"  #FIXME: Result of the command (kubectl get nodes -o json |  jq -r '.items[0].status.addresses[0].address')
        #"spark.driver.bindAddress": "0.0.0.0"
   ```
   This lines are required to run dbt on airflow but have to be commented while running dbt in notebook.

   c)update git clone command to point to ***your fork***.
   git clone command updated:
   ```
         %%bash
         mkdir -p git && cd git
         git clone --branch notebook https://github.com/RadoslawKasprzak/tbd-tpc-di.git
         cd tbd-tpc-di
         git pull
   ```

 


8. Access Vertex AI Workbench and run cell by cell notebook `tpc-di-setup.ipynb`.

    a) in the first cell of the notebook replace: `%env DATA_BUCKET=tbd-2023z-9910-data` with your data bucket.
    ```
          %env DATA_BUCKET=tbd-2025z-335202-data
          %env GEN_OUTPUT_DIR=/tmp/tpc-di
          %env REPO_ROOT=/home/jupyter/git/tbd-tpc-di/
   ```

   b) in the cell:
         ```%%bash
         mkdir -p git && cd git
         git clone https://github.com/mwiewior/tbd-tpc-di.git
         cd tbd-tpc-di
         git pull
         ```
      replace repo with your fork. Next checkout to 'notebook' branch.

   git clone command updated:
   ```
         %%bash
         mkdir -p git && cd git
         git clone --branch notebook https://github.com/RadoslawKasprzak/tbd-tpc-di.git
         cd tbd-tpc-di
         git pull
   ```
    c) after running first cells your fork of `tbd-tpc-di` repository will be cloned into Vertex AI  enviroment (see git folder).
    git folder tbd-tpc-di created:
    ![image](https://github.com/user-attachments/assets/75251741-0f1f-42f3-811b-4bab6d17a522)  

    d) take a look on `git/tbd-tpc-di/profiles.yaml`. This file includes Spark parameters that can be changed if you need to increase the number of executors and
  ```
   server_side_parameters:
       "spark.driver.memory": "2g"
       "spark.executor.memory": "4g"
       "spark.executor.instances": "2"
       "spark.hadoop.hive.metastore.warehouse.dir": "hdfs:///user/hive/warehouse/"
  ```
  ![image](https://github.com/user-attachments/assets/3347555c-e39f-4fb3-8a99-6cb6f34e0ced)


7. Explore files created by generator and describe them, including format, content, total size.


    All work done
    Data generation finished successfully
    AuditTotalRecordsSummaryWriter - TotalRecords for Batch1: 160873381
    AuditTotalRecordsSummaryWriter - TotalRecords for Batch2: 677582
    AuditTotalRecordsSummaryWriter - TotalRecords for Batch3: 677508
    AuditTotalRecordsSummaryWriter - TotalRecords all Batches: 162228471 220669.47 records/second
    Statistics  
    
    Overall time    0h:12m:15s:164ms
    Generated       9.6 GiB
    Speed           13.4 MiB/s
    
    DIGen completed successfully.

    Generated files are stored in /tmp/tcp-di/:
    drwxr-xr-x 2 root root 20480 Jan 11 18:39 Batch1
    -rw-r--r-- 1 root root   113 Jan 11 18:27 Batch1_audit.csv
    drwxr-xr-x 2 root root  4096 Jan 11 18:36 Batch2
    -rw-r--r-- 1 root root   113 Jan 11 18:27 Batch2_audit.csv
    drwxr-xr-x 2 root root  4096 Jan 11 18:36 Batch3
    -rw-r--r-- 1 root root   113 Jan 11 18:27 Batch3_audit.csv
    -rw-r--r-- 1 root root  3203 Jan 11 18:27 Generator_audit.csv
    -rw-r--r-- 1 root root   587 Jan 11 18:39 digen_report.txt
    
    Folder Batch1:
    Content: The Batch1 directory contains a mix of generated data files (e.g., CashTransaction.txt, DailyMarket.txt, Trade.txt, WatchHistory.txt) and their corresponding audit files (e.g., CashTransaction_audit.csv, Trade_audit.csv). It includes both large datasets and metadata files for auditing, organized by entities (e.g., FINWIRE, TaxRate, TradeHistory).
    Total Size: The total size of the directory is approximately 9.4 GB, dominated by large .txt files such as Trade.txt (1.33 GB), WatchHistory.txt (1.43 GB), and TradeHistory.txt (1.11 GB).
    Format: Data is stored in text files (.txt) and CSV files (.csv), where .txt files likely represent raw generated datasets, and .csv files provide summaries or audit information for validation purposes.
    
    Folder Batch2:
    Content: The Batch2 directory contains generated data files (Account.txt, CashTransaction.txt, DailyMarket.txt, Trade.txt, WatchHistory.txt) representing various entities, alongside their corresponding audit files (e.g., Account_audit.csv, Trade_audit.csv). 
    Total Size: The total size of the directory is approximately 114 MB, with the largest file being Prospect.csv at ~105 MB, followed by moderately sized files like DailyMarket.txt (~5 MB) and Trade.txt (~1.8 MB).
    Format: Data files are stored in text files (.txt) for structured data and CSV files (.csv) for audit metadata. The .txt files likely represent the raw datasets, while the .csv files validate the correctness and completeness of the data.

    Folder Batch3:
    Content: The Batch2 directory contains data files (Account.txt, Customer.txt, CashTransaction.txt, DailyMarket.txt, Trade.txt, WatchHistory.txt, Prospect.csv) and their corresponding audit files (*_audit.csv). These files represent transactional, market, and customer-related data, alongside metadata for data validation.
    Total Size: The directory's total size is approximately 114.6 MB, with the largest file being Prospect.csv (~104.9 MB), followed by DailyMarket.txt (~5.3 MB) and WatchHistory.txt (~4.1 MB).
    Format: The data is stored in text files (.txt) for transactional and structured data, while CSV files (.csv) are used for auditing and validation purposes. These formats support easy integration with data processing pipelines.

    In /tmp/tpc-di/ there are also:
    -rw-r--r-- 1 root root   113 Jan 11 18:27 Batch1_audit.csv
    -rw-r--r-- 1 root root   113 Jan 11 18:27 Batch2_audit.csv
    -rw-r--r-- 1 root root   113 Jan 11 18:27 Batch3_audit.csv
    -rw-r--r-- 1 root root  3203 Jan 11 18:27 Generator_audit.csv
    -rw-r--r-- 1 root root   587 Jan 11 18:39 digen_report.txt
    Batch1_audit.csv, Batch2_audit.csv, Batch3_audit.csv: Contain DataSet, BatchID ,Date , Attribute , Value, DValue for each data generation batch.
    Generator_audit.csv: content DataSet, BatchID ,Date , Attribute , Value, DValue
    digen_report.txt: Report of the TPC-DI Data Generation process - start time, end time, software versions, number of records for every batch
   
9. Analyze tpcdi.py. What happened in the loading stage?

   ***Your answer***

10. Using SparkSQL answer: how many table were created in each layer?

   ***SparkSQL command and output***

11. Add some 3 more [dbt tests](https://docs.getdbt.com/docs/build/tests) and explain what you are testing. ***Add new tests to your repository.***

   ***Code and description of your tests***

11. In main.tf update
   ```
   dbt_git_repo            = "https://github.com/mwiewior/tbd-tpc-di.git"
   dbt_git_repo_branch     = "main"
   ```
   so dbt_git_repo points to your fork of tbd-tpc-di. 

12. Redeploy infrastructure and check if the DAG finished with no errors:

***The screenshot of Apache Aiflow UI***
