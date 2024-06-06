# Phase 2a

IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.

![img.png](doc/figures/destroy.png)

1. The goal of this phase is to create infrastructure, perform benchmarking/scalability tests of sample three-tier lakehouse solution and analyze the results using:

    * [TPC-DI benchmark](https://www.tpc.org/tpcdi/)
    * [dbt - data transformation tool](https://www.getdbt.com/)
    * [GCP Composer - managed Apache Airflow](https://cloud.google.com/composer?hl=pl)
    * [GCP Dataproc - managed Apache Spark](https://spark.apache.org/)
    * [GCP Vertex AI Workbench - managed JupyterLab](https://cloud.google.com/vertex-ai-notebooks?hl=pl)

    Worth to read:

    * <https://docs.getdbt.com/docs/introduction>
    * <https://airflow.apache.org/docs/apache-airflow/stable/index.html>
    * <https://spark.apache.org/docs/latest/api/python/index.html>
    * <https://medium.com/snowflake/loading-the-tpc-di-benchmark-dataset-into-snowflake-96011e2c26cf>
    * <https://www.databricks.com/blog/2023/04/14/how-we-performed-etl-one-billion-records-under-1-delta-live-tables.html>

2. Authors:

   gr-3

   <https://github.com/Pinjesz/tbd-workshop-1>

3. Sync your repo with <https://github.com/bdg-tbd/tbd-workshop-1>.

4. Provision your infrastructure.

   a) setup Vertex AI Workbench `pyspark` kernel as described in point [8](https://github.com/bdg-tbd/tbd-workshop-1/tree/v1.0.32#project-setup)

   b) upload [tpc-di-setup.ipynb](https://github.com/bdg-tbd/tbd-workshop-1/blob/v1.0.36/notebooks/tpc-di-setup.ipynb) to the running instance of your Vertex AI Workbench

5. In `tpc-di-setup.ipynb` modify cell under section ***Clone tbd-tpc-di repo***:

   a)first, fork <https://github.com/mwiewior/tbd-tpc-di.git> to your github organization.

   b)create new branch (e.g. 'notebook') in your fork of tbd-tpc-di and modify profiles.yaml by commenting following lines:

   ```terraform
        #"spark.driver.port": "30000"
        #"spark.blockManager.port": "30001"
        #"spark.driver.host": "10.11.0.5"  #FIXME: Result of the command (kubectl get nodes -o json |  jq -r '.items[0].status.addresses[0].address')
        #"spark.driver.bindAddress": "0.0.0.0"
   ```

   This lines are required to run dbt on airflow but have to be commented while running dbt in notebook.

   c)update git clone command to point to ***your fork***.

6. Access Vertex AI Workbench and run cell by cell notebook `tpc-di-setup.ipynb`.

    a) in the first cell of the notebook replace: `%env DATA_BUCKET=tbd-2023z-9910-data` with your data bucket.

    b) in the cell:
        ```%%bash
        mkdir -p git && cd git
        git clone https://github.com/mwiewior/tbd-tpc-di.git
        cd tbd-tpc-di
        git pull
        ```
        replace repo with your fork. Next checkout to 'notebook' branch.

    c) after running first cells your fork of `tbd-tpc-di` repository will be cloned into Vertex AI  enviroment (see git folder).

    d) take a look on `git/tbd-tpc-di/profiles.yaml`. This file includes Spark parameters that can be changed if you need to increase the number of executors and

    ```terraform
    server_side_parameters:
        "spark.driver.memory": "2g"
        "spark.executor.memory": "4g"
        "spark.executor.instances": "2"
        "spark.hadoop.hive.metastore.warehouse.dir": "hdfs:///user/hive/warehouse/"
    ```

7. Explore files created by generator and describe them, including format, content, total size.

    Generator created 217 files:

    14 text files (txt, csv, xml)

    ![tables](doc/figures/gen-tables.png)

    that store data for tables

    ![table_logs](doc/figures/gen-logs.png)

    203 FINWIRE files, one for each quarter from 1967Q1 to 2017Q3, that contains some data as well, sizing from 163.9 KB to 10.4 MB

    ![finwire](doc/figures/gen-finwire.png)

8. Analyze tpcdi.py. What happened in the loading stage?

    This script loads data from generated files and uploads it into tables.
    Firstly it starts a spark session and creates a data base on hive for digen, bronze, silver and gold.
    Sets a digen data base to be used. Then for each file (except FINWIRE, it processes all of them at once) it creates DataFrame
    and uploads it to blob.

9. Using SparkSQL answer: how many table were created in each layer?

    ![spark-tables](doc/figures/spark-tables.png)

10. Add some 3 more [dbt tests](https://docs.getdbt.com/docs/build/tests) and explain what you are testing.

    correct_day_names.sql: checks if day names are correct

    ```sql
    select *
    from {{ ref('dim_date') }}
    where day_of_week_desc not in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
    ```

    noncurrent_not_max_end_timestamp.sql: checks if all records with max value in end_timestamp are current (is_current='true')

    ```sql
    select *
    from {{ ref('dim_account') }}
    where end_timestamp='9999-12-31 23:59:59.999' and is_current='false'
    ```

    date_removed_after_placed.sql: checks date removed is not before placed

    ```sql
    select *
    from {{ ref('fact_watches') }}
    where sk_date_placed > sk_date_removed
    ```

11. In main.tf update

    ```terraform
    dbt_git_repo            = "https://github.com/mwiewior/tbd-tpc-di.git"
    dbt_git_repo_branch     = "main"
    ```

    so dbt_git_repo points to your fork of tbd-tpc-di.

12. Redeploy infrastructure and check if the DAG finished with no errors:

![alt text](doc/figures/apache_airflow.png)
