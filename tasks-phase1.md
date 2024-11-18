IMPORTANT ❗ ❗ ❗ Please remember to destroy all the resources after each work session. You can recreate infrastructure by creating new PR and merging it to master.
  
![img.png](doc/figures/destroy.png)

1. Authors:

   ***enter your group nr*** \
   14

   ***link to forked repo***\
   https://github.com/BartoszWaracki/tbd-workshop-1
   
3. Follow all steps in README.md.
   Wykonaliśmy wszystkie punkty wskazane w README.md czego rezultatem był pull request. Zarówno pipeline związany z IAC jak i ten z releasem wykonały się prawidłowo:
<img width="928" alt="image" src="https://github.com/user-attachments/assets/1d51afe7-dce6-4a83-bd01-2132664c4bdd">
<img width="975" alt="image" src="https://github.com/user-attachments/assets/15352158-8963-44c7-a979-3395e7e347ff">




5. Select your project and set budget alerts on 5%, 25%, 50%, 80% of 50$ (in cloud console -> billing -> budget & alerts -> create buget; unclick discounts and promotions&others while creating budget).

  ![img.png](doc/figures/discounts.png)

  Stworzyliśmy budżet dla naszego projektu: TBD-2024Z-GR14
  Ustawiliśmy alerty dla budżetu na poziomach wskazancyh w poleceniu, czyli 5%, 25%, 50%, 80% i początkowych środków w ilości 50$. Wyłączyliśmy opcję "discounts and promotions&others"
  
  ![image](https://github.com/user-attachments/assets/8761fb19-0dbd-497b-ad91-9e3be0fd283d)

  ![image](https://github.com/user-attachments/assets/9ef4fe53-bff4-4ced-a5dd-c22adb880ef7)


5. From avaialble Github Actions select and run destroy on main branch.
   Uruchomiliśmy akcję Destroy na branchu master, która zakończyła się sukcesem:
   <img width="980" alt="image" src="https://github.com/user-attachments/assets/e01133b8-ab05-4c94-8b1c-89085878e8a7">

   
7. Create new git branch and:
    1. Modify tasks-phase1.md file.
    2. Create PR from this branch to **YOUR** master and merge it to make new release. 
    ***place the screenshot from GA after succesfull application of release***
       Zmodyfikowaliśmy plik, a następnie stworzyliśmy pull request do mastera, tak aby ztriggerować akcję release w githubie. Zakończyła się ona sukcesem:
       <img width="1018" alt="image" src="https://github.com/user-attachments/assets/d14a2f1d-f448-4023-a377-edcbe988e62e">


8. Analyze terraform code. Play with terraform plan, terraform graph to investigate different modules.

    ***describe one selected module and put the output of terraform graph for this module here***
   
   Wybranym modułem jest *vertex-ai-workbench*.

Moduł służy do tworzenia maszyny wirtualnej z gotowym obrazem dysku, który zawiera wszystkie narzędzia potrzebne do pracy z infrastrukturą przetwarzającą dane w ramach analiz Big Data. Rozwiązanie to upraszcza proces i jest bardziej wydajne niż konfigurowanie lokalnego komputera użytkownika do współpracy z zasobami chmurowymi. Dodatkowo, maszyna wirtualna zapewnia łatwy dostęp do interfejsu webowego, co ułatwia jej obsługę.

Podstawową funkcjonalnością modułu jest uruchomienie maszyny wirtualnej, realizowane za pomocą zasobu google_notebooks_instance, który odpowiada za jej konfigurację i przygotowanie środowiska pracy. Dostęp do usług Google, takich jak API notebooków, jest zarządzany przy użyciu google_project_service. Aby umożliwić korzystanie z tych usług przez konto serwisowe, za pośrednictwem którego generowane są tymczasowe poświadczenia, wykorzystywany jest zasób google_project_iam_binding.

Ponadto moduł tworzy zasób google_storage_bucket, który zapewnia przestrzeń do przechowywania plików w Google Cloud Storage (GCS). Dostęp do tych danych, ograniczony jedynie do odczytu, jest przyznawany kontu serwisowemu za pomocą google_storage_bucket_iam_binding. Skrypt inicjalizacyjny, który uruchamia się po starcie maszyny, jest przesyłany do przestrzeni GCS poprzez zasób google_storage_bucket_object w trakcie wykonywania polecenia terraform apply.

   Po wywołaniu komendy *terraform graph -type=plan | dot -Tpng >graph.png* w *modules/vertex-ai-workbench*
wygenerowany został plik .png z grafem dla wybranego modułu:
![graph](https://github.com/user-attachments/assets/ecf1235d-0c30-40c5-a780-6ad582c3567a)

   
10. Reach YARN UI
   
   ***place the command you used for setting up the tunnel, the port and the screenshot of YARN UI here***
   Najpierw zdefiniowaliśmy zmienne:\
   export PROJECT=tbd-2024z-310164;export HOSTNAME=tbd-cluster-m;export ZONE=europe-west1-d;PORT=1080\
   Następnie postawiliśmy tunel SSH:\
   gcloud compute ssh ${HOSTNAME} \
    --project=${PROJECT} --zone=${ZONE}  -- \
    -D ${PORT} -N
Po czym otworzyliśmy przedglądarkę komendą:
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    --proxy-server="socks5://localhost:${PORT}" \
    --user-data-dir=/tmp/${HOSTNAME} \
Na końcu przeszliśmy do YARN UI przez poniższy URL (8088 to port dla YARN ResourceManager w daraproc)
http://tbd-cluster-m:8088/
    
  ![image](https://github.com/user-attachments/assets/78f91082-17b0-433a-aa8a-c223c5ececc2)

11. Draw an architecture diagram (e.g. in draw.io) that includes:
    1. VPC topology with service assignment to subnets
    2. Description of the components of service accounts
    3. List of buckets for disposal
    4. Description of network communication (ports, why it is necessary to specify the host for the driver) of Apache Spark running from Vertex AI Workbech
  
    ***place your diagram here***

12. Create a new PR and add costs by entering the expected consumption into Infracost
For all the resources of type: `google_artifact_registry`, `google_storage_bucket`, `google_service_networking_connection`
create a sample usage profiles and add it to the Infracost task in CI/CD pipeline. Usage file [example](https://github.com/infracost/infracost/blob/master/infracost-usage-example.yml) 

   Wykorzystaliśmy podany plik przykładowy i uzupełniliśmy go spodziewanymi wartościami konsumpcji. [here](infracost-usage.yml) \\
   <img width="399" alt="image" src="https://github.com/user-attachments/assets/25e29d61-71be-4212-8445-ad3c0e486b7e"> \
Zmodyfikowaliśmy również CI/CD pipeline przez dodanie *--usage-file* do taska "Generate Infracost cost estimate baseline" \
<img width="625" alt="image" src="https://github.com/user-attachments/assets/fe4b9251-24ce-474a-8dda-6a1a9c14ef3d">

   Po wywołaniu komendy infracost breakdown --path . --usage-file infracost-usage.yml otrzymaliśmy następujący rezultat: \
![MicrosoftTeams-image](https://github.com/user-attachments/assets/208c38f7-e9b9-45c2-bedd-c6110a98d127) \
<img width="902" alt="image" src="https://github.com/user-attachments/assets/7fb422fc-c494-41c6-afe8-09455d03ac53"> \

11. Create a BigQuery dataset and an external table using SQL
    
    ***CREATE SCHEMA IF NOT EXISTS demo OPTIONS(location = 'europe-west1');
 
CREATE OR REPLACE EXTERNAL TABLE demo.shakespeare
  OPTIONS (
  
  format = 'ORC',
  uris = ['gs://tbd-2024z-310164-data/data/shakespeare/*.orc'])***

   Output:
   
   <img width="852" alt="MicrosoftTeams-image (30)" src="https://github.com/user-attachments/assets/cca39559-4105-4bd3-a5d4-d97dbe52d07a">

    ***why does ORC not require a table schema?***
Format ORC (Optimized Row Columnar) nie wymaga schematu, ponieważ zawiera wbudowane metadane opisujące strukturę danych, takie jak nazwy pól i typy danych. Dzięki temu BigQuery automatycznie rozpoznaje schemat danych podczas tworzenia tabeli zewnętrznej, bez potrzeby ręcznego definiowania go.

  
12. Start an interactive session from Vertex AI workbench:

   

   <img width="1389" alt="MicrosoftTeams-image (31)" src="https://github.com/user-attachments/assets/da67a998-e105-42a8-aa1c-5528dddffbd5">
   
w celu odpalenia interaktywnej sesji użyto polecenia:

   gcloud compute --project "tbd-2024z-310164" ssh --zone "europe-west1-b" "tbd-2024z-310164-notebook" -- -L 8080:localhost:8080
   
13. Find and correct the error in spark-job.py
    
Opis błędu :

<img width="859" alt="MicrosoftTeams-image (32)" src="https://github.com/user-attachments/assets/c54be1d7-fe50-414d-8247-f08b0f704e77">
<img width="932" alt="MicrosoftTeams-image (33)" src="https://github.com/user-attachments/assets/3c1bd198-b7b4-46b3-ac3c-e9784923f3af">
Błąd znaleziono w GCP w Dataproc i w jego Jobach. Tam wystarczyło kliknąć jeden ze zfailowanych jobów aby zobaczyć opis błędu.
Bład wystąpił dlatego, że scieżka do bucketu w pliku spakr-job.py była błędna.
Aby naprawić występujący błąd należy poprawić początkowy plik spark-job.py, ustawiając odpowienią wartość, dla naszego projektu:

DATA_BUCKET = "gs://tbd-2024z-310164-data/data/shakespeare/"


14. Additional tasks using Terraform:

    1. Add support for arbitrary machine types and worker nodes for a Dataproc cluster and JupyterLab instance

    [Commit](https://github.com/BartoszWaracki/tbd-workshop-1/commit/2ddbc18715d28a0e0ed800ff1b1c4a0715f3e18f)
    
    2. Add support for preemptible/spot instances in a Dataproc cluster

    [Commit](https://github.com/BartoszWaracki/tbd-workshop-1/commit/65027d7378710137a98e3a32bc3eb1d0df059c6c)
    
    3. Perform additional hardening of Jupyterlab environment, i.e. disable sudo access and enable secure boot
    
    [Commit](https://github.com/BartoszWaracki/tbd-workshop-1/commit/aa618ff78a6e4b04a6f192d4260342fd8a904210)

    4. (Optional) Get access to Apache Spark WebUI
    
    Uzyskałem dostęp do Apache Spark WebUI poprzez puszczenie Joba, a następnie w YARN UI przejście w tym jobie do ApplicationMAster w kolumnie Tracking UI

<img width="1184" alt="MicrosoftTeams-image (34)" src="https://github.com/user-attachments/assets/8573899a-fcaa-483a-a35a-2a6ca590342a">

[Commit](https://github.com/BartoszWaracki/tbd-workshop-1/commit/d8397b55477a564bb5ef20c65ab82fef9fda7a69)
