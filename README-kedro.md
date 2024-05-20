# TBD Workshop 2. Kedro

## Workshop goals

TODO
## Prerequisites
* TBD Workshop 1 infrastructure running - VertexAI Workbench Jupyter Lab accessed
* Linux/MacOS

1. Create Anaconda environment

```bash 
  conda create --name mlops-adac python=3.8 -y
```

2. Initialize Anaconda in terminal

```bash
  conda init
```
Restart the bash session after running the above command.

3. Activate the conda environment

```bash
  conda activate mlops-adac
```

4. Install Kedro

```bash
  pip install kedro==0.19.3
```

5. Create a new Kedro project

```bash
  kedro new --starter  https://github.com/mwiewior/kedro-starters/ --directory spaceflights-pyspark-mlflow --checkout spaceflights-pyspark-mlflow
```

Set the nnme for your new project: `adac-kedro-pyspark`

6. Change the directory to the newly created project

```bash
  cd adac-kedro-pyspark
```

7. Configure required environment variables

```bash
  export PYSPARK_PIN_THREAD=false
```


8. Install the project dependencies

```bash
  pip install -r requirements.txt
```

This step will last for ~10 minutes. Meanwhile, you can explore the kedro project structure and content, and continue with the next steps.

9. Create a new bucket in the same region as the rest of the infrastructure

```bash
  # instead of XXXX use your user id from the name of the project
  export USER_ID=XXXX
  gsutil mb -l europe-west1 gs://adac-kedro-pyspark-${USER_ID}
```

10. Copy the raw data to the newly created bucket

```bash
  gsutil cp -r data/01_raw/* gs://adac-kedro-pyspark-${USER_ID}/01_raw/
```

11. Run the MLflow

For running the Mlflow instance, 

11. Run the Kedro pipeline

```bash
  kedro run
```
