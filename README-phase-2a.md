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

1. Authors:

   ***Enter your group nr*** \
   14

   ***Link to forked repo*** \
   https://github.com/BartoszWaracki/tbd-workshop-1
   
3. Sync your repo with https://github.com/bdg-tbd/tbd-workshop-1.

4. Provision your infrastructure.

    a) setup Vertex AI Workbench `pyspark` kernel as described in point [8](https://github.com/bdg-tbd/tbd-workshop-1/tree/v1.0.32#project-setup)
   
      <img width="1002" alt="MicrosoftTeams-imagebf22abfdfade1739fe20324ec7d9c922892ed0b7f74f6bcb17ab74815fcd2bd8" src="https://github.com/user-attachments/assets/91de65c6-5532-44a7-8cd7-2140399fdb21" />
   
    b) upload [tpc-di-setup.ipynb](https://github.com/bdg-tbd/tbd-workshop-1/blob/v1.0.36/notebooks/tpc-di-setup.ipynb) to 
the running instance of your Vertex AI Workbench

6. In `tpc-di-setup.ipynb` modify cell under section ***Clone tbd-tpc-di repo***:

   a)first, fork https://github.com/mwiewior/tbd-tpc-di.git to your github organization.

   Repozytorium znajduje się w [lokalizacji](https://github.com/kraszor/tbd-tpc-di)

   b)create new branch (e.g. 'notebook') in your fork of tbd-tpc-di and modify profiles.yaml by commenting following lines:
   ```  
        #"spark.driver.port": "30000"
        #"spark.blockManager.port": "30001"
        #"spark.driver.host": "10.11.0.5"  #FIXME: Result of the command (kubectl get nodes -o json |  jq -r '.items[0].status.addresses[0].address')
        #"spark.driver.bindAddress": "0.0.0.0"
   ```
   This lines are required to run dbt on airflow but have to be commented while running dbt in notebook.

   Odpowiednie linie zostały zakomentowane:
   
   <img width="900" alt="MicrosoftTeams-image5da315b661262c9930f271790a4df905842b3bf6fe22ab12215c4fc252952c49" src="https://github.com/user-attachments/assets/a73132bd-e0d6-43fa-b4b1-75c87005cff7" />

   c)update git clone command to point to ***your fork***.

   <img width="503" alt="MicrosoftTeams-imagec90083218c24dff5fd4af9cd622de6aab22195054c4214fea313203848878167" src="https://github.com/user-attachments/assets/b6801e81-cc16-4ff4-8c32-c8f66ba9833a" />

8. Access Vertex AI Workbench and run cell by cell notebook `tpc-di-setup.ipynb`.

    a) in the first cell of the notebook replace: `%env DATA_BUCKET=tbd-2023z-9910-data` with your data bucket.
   
    <img width="526" alt="MicrosoftTeams-image82de188d1ba391cd78167a04de502b3e98e42f007a5b76853069ce923de5c78f" src="https://github.com/user-attachments/assets/683710f5-28e4-439b-9290-740cb73fb356" />

   b) in the cell:
         ```%%bash
         mkdir -p git && cd git
         git clone https://github.com/mwiewior/tbd-tpc-di.git
         cd tbd-tpc-di
         git pull
         ```
      replace repo with your fork. Next checkout to 'notebook' branch.

    <img width="503" alt="MicrosoftTeams-imagec90083218c24dff5fd4af9cd622de6aab22195054c4214fea313203848878167" src="https://github.com/user-attachments/assets/b6801e81-cc16-4ff4-8c32-c8f66ba9833a" />
   
  c) after running first cells your fork of `tbd-tpc-di` repository will be cloned into Vertex AI  enviroment (see git folder).

  d) take a look on `git/tbd-tpc-di/profiles.yaml`. This file includes Spark parameters that can be changed if you need to increase the number of executors and
  ```
   server_side_parameters:
       "spark.driver.memory": "2g"
       "spark.executor.memory": "4g"
       "spark.executor.instances": "2"
       "spark.hadoop.hive.metastore.warehouse.dir": "hdfs:///user/hive/warehouse/"
  ```

6. Explore files created by generator and describe them, including format, content, total size.

   Łączny rozmiar wygenerowanych plików wynosił: 9,6 GiB. \
   Pliki zostały utworzone przez generator w postaci trzech batchy. \
   Każdy z batchy zawierał pliki w formatach: csv, txt, xml oraz bez podanego rozszerzenia.

   Statystyki dotyczące łącznego rozmiaru plików dla poszczególnych typów danych:
     * StatusType: 3,6 KiB
     * TaxRate: 16,7 KiB
     * Date: 3,3 MiB
     * Time: 4,6 MiB
     * BatchDate: 88 B
     * HR: 39,6 MiB
     * CustomerMgmt: 298,1 MiB
     * Customer: 205,3 KiB
     * Account: 149,6 KiB
     * Prospect: 300,2 MiB
     * Industry: 2,7 KiB
     * FINWIRE: 1 GiB (Pliki znajdowały się jedynie w pierwszym batchu.)
     * DailyMarket: 3 GiB
     * WatchHistory: 1,3 GiB
     * TradeSource: 3,6 GiB
     * TradeType: 5 wierszy

Poniższe zrzuty ekranu prezentują statystyki z generacji plików:

<img width="986" alt="MicrosoftTeams-imagea77c0b18f4f2037fd91dd4b60cae36a1b0a798869cb4e9625f46f3875cf3804b" src="https://github.com/user-attachments/assets/db35205f-39ea-42b6-ab0a-bba0710375b1" />

<img width="874" alt="MicrosoftTeams-imageb150ac5873645f8e11d8bf3e915c83669a3a32ec4827c2c1fec5895a7c4f89e5" src="https://github.com/user-attachments/assets/4e5efd2e-6177-4bb4-9192-370cc6659814" />

<img width="730" alt="MicrosoftTeams-imagea607c48e4dbb610a1e47ce479919d9c8d5d9602a7781117cd18cc563a0f6a186" src="https://github.com/user-attachments/assets/8a5a663d-5de3-4104-93a5-5aeec610a4ba" />

Poniższe zrzuty ekranu pokazują dane dla batchy 2 oraz 3. (Z uwagi na dużą ilość plików znajdujących się w folderze dla batcha 1, pominęliśmy zrzut ekranu jego zawartości.)

<img width="926" alt="MicrosoftTeams-image84927a20f36ff39b5b6b2c0c12a698727500a25aaf9de667156f3bbce9b37919" src="https://github.com/user-attachments/assets/159feb36-0bbc-43df-9c8b-c73fab94e718" /> 

<img width="943" alt="MicrosoftTeams-image59b39c875663d19ec039126ee3cede80ca13e68cf68c88e07a444643c8091f26" src="https://github.com/user-attachments/assets/ec2a7886-e865-4737-ad9c-47b7118dc24d" />

7. Analyze tpcdi.py. What happened in the loading stage?

   Plik tpcdi.py dotyczy tworzenie tabel na podstawie danych z generatora w fazie loading stage.
   Początkowo tworzona jest sesja Sparka oraz odpowiednie bazy danych, a baza 'digen' ustawiana jest jako baza domyślna.
   Dla każdej z tabel określona jest struktura, a dane wczytywane są bezpośrednio z plików.
   Na podstawie danych tworozne są struktury dataframe, które są następnie zapisywane w formacie parquet tworząc tabele w bazie danych 'digen'.

  <img width="941" alt="MicrosoftTeams-image19870d72dcabaeeb3554d6cf161b48e695d693b40494592e5954744d3cc4f492" src="https://github.com/user-attachments/assets/cfd95451-b896-4eb1-83d8-dd49e6ee9803" />
  <img width="904" alt="MicrosoftTeams-image4bc94f49f98d70734c467e56c7854164d090c769f99015810dd9e53b02d39e89" src="https://github.com/user-attachments/assets/2ff0d989-4e9a-47be-9914-3c47efc226cc" />
  <img width="894" alt="MicrosoftTeams-image11497715aae8953c66ed5e1abea66bc8ba4fb3e7f3c9134c303e86a16bdff947" src="https://github.com/user-attachments/assets/3bff87d9-4cf0-49f4-ac59-9ad1972d76c0" />

8. Using SparkSQL answer: how many table were created in each layer?

  W warstwie demo_bronze zostało utworzonych 17, w warstwie demo_silver 14, a w warstwie demp_gold 12 tabel. W warstwach bronze, silver oraz gold nie zostały utworzone żadne tabele.

  <img width="475" alt="MicrosoftTeams-imagebe6c1e83cdbbf453de3c59460b1823b8a27fb7000e4bb87518d698ccc452f540" src="https://github.com/user-attachments/assets/05462120-dbd0-430d-b9c2-ccf8c101c5fb" /> \
  <img width="379" alt="MicrosoftTeams-image5e0324e9108a57735ecd4ecd55238b07e1281b177df8c936c5522000b97dc582" src="https://github.com/user-attachments/assets/64dbcd8b-c8bd-49cd-930e-61842dc2b8e3" /> \
  <img width="346" alt="MicrosoftTeams-image9d65722e9728f6fa46d4b0e43d32e11dc707485322734e943597e0d85c67ddd4" src="https://github.com/user-attachments/assets/2cbf9062-df18-498b-9a3f-7525c129e9f0" /> \

  <img width="492" alt="MicrosoftTeams-imagecc4dd6769707244d0854c0751103a51d80f40e8a71c487e50232b6835a1145a3" src="https://github.com/user-attachments/assets/7fb4fe25-5dd1-4342-ba83-f962341a8c2d" />
  <img width="522" alt="MicrosoftTeams-imageafef16797bf7fe4e76c3e506849a9bc9f8dc803a11a7bc4315366c2a270271a9" src="https://github.com/user-attachments/assets/2d4d94e3-1fd0-4d83-beda-84d8825b2a69" /> \
  <img width="521" alt="MicrosoftTeams-image096af2a3561dfbcc68962f1ff1970becbc99832da55493221dcd8adb2a863aca" src="https://github.com/user-attachments/assets/846aa797-b86e-41f4-9492-9756ccef8a78" /> \

9. Add some 3 more [dbt tests](https://docs.getdbt.com/docs/build/tests) and explain what you are testing. 

Testy znajdują się w tej [lokalizacji](https://github.com/kraszor/tbd-tpc-di/tree/main/tests)

  * Test 1 - sprawdzenie, czy w tabeli dim_account nie występują duplikaty primary key (sk_account_id)
   
       select sk_account_id, count(*) cnt \
       from {{ ref('dim_account') }} \
       group by sk_account_id \
       having cnt > 1 

  * Test 2 - sprawdzenie, czy w tabeli dim_account nie występują wartości null w kolumnie sk_account_id (primary key)

       select sk_account_id \
       from {{ ref('dim_account') }} \
       where sk_account_id is null

  * Test 3 - sprawdzenie, czy w tabeli fact_watches nie występują rekordy z datą utworzenia późniejszą niż data skasowania

       select sk_customer_id \
       from {{ ref('fact_watches') }} \
       where sk_date_placed > coalesce(sk_date_removed, sk_date_placed)

Potwierdzenie przeprowadzenia testów:

<img width="866" alt="MicrosoftTeams-imageafef1b333a21407c9fcff9cadba79f4bd66efc0d8719280f33b7df9b63f752ee" src="https://github.com/user-attachments/assets/de13c4d8-2317-4af8-89e6-eba2ff6a36b3" />

11. In main.tf update
   ```
   dbt_git_repo            = "https://github.com/mwiewior/tbd-tpc-di.git"
   dbt_git_repo_branch     = "main"
   ```
   so dbt_git_repo points to your fork of tbd-tpc-di.

   <img width="696" alt="MicrosoftTeams-image19731d4704798a6728dba4839fc4a70f025dbe5b7b63c1fd4530e2922e08ebec" src="https://github.com/user-attachments/assets/0283771a-dabc-491e-91e9-3e9fbd31c923" />

11. Redeploy infrastructure and check if the DAG finished with no errors:

  <img width="1188" alt="MicrosoftTeams-image2b7229a3c85043c3051fcbb0e9610194417dd28096e314b6dd56fab9dc7eb8a7" src="https://github.com/user-attachments/assets/72458aaa-e09a-41e9-81b9-3b3d161dfe4f" />

