# TBD Workshop 2. Kedro
[Spaceflights tutorial](https://docs.kedro.org/en/stable/tutorial/spaceflights_tutorial.html)

## Workshop goals

1. Learn how to use Kedro for building reproducible, maintainable, and modular data pipelines.
2. Learn how to use PySpark (local mode and deployed on YARN) for data processing together with Kedro.
3. Learn how to use MLflow for tracking experiments and managing machine learning models.
4. Learn how to use Kedro-Viz for visualizing the data pipeline.
5. 

## Prerequisites
* TBD Workshop 1 infrastructure running - VertexAI Workbench Jupyter Lab accessed
* Linux/MacOS

1. Initialize Anaconda in terminal

```bash
  conda init
```
Restart the bash session after running the above command.

2. Create Anaconda environment

```bash 
  conda create --name mlops-adac python=3.8 -y
```



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
9. Run the MLflow

For running the Mlflow instance,

10. Run the Kedro pipeline

```bash
  kedro run
```
11. Check experiment runs in MLflow



## Running in the Dataproc cluster
1. Create a new bucket in the same region as the rest of the infrastructure

```bash
  # instead of XXXX use your user id from the name of the project
  export USER_ID=mwiewior
  export MLOPS_ENV=gcp-dev
  export DEV_BUCKET=gs://adac-mlops-${MLOPS_ENV}-${USER_ID}
  gsutil mb -l europe-west1 $DEV_BUCKET
```
2. Copy the raw data to the newly created bucket

```bash
  gsutil cp -r data/01_raw/* ${DEV_BUCKET}/data/01_raw/
```


3. Run the Kedro pipeline using `gcp-dev` (ensure that `DEV_BUCKET` environment variable is set correctly)

```bash
  kedro run --env=gcp-dev

```bash
  kedro run --env=gcp-dev

```bash
  kedro run --env=gcp-dev
```
