# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Check out the Dataproc Serverless workloads with Cloud Composer guide at
# https://cloud.google.com/composer/docs/composer-2/run-dataproc-workloads for more details.

# [START composer_dataproc_create_batch]

"""
Examples below show how to use operators for managing Dataproc Serverless batch workloads.
 You use these operators in DAGs that create, delete, list, and get a Dataproc Serverless Spark batch workload.
https://airflow.apache.org/docs/apache-airflow/stable/concepts/variables.html
* project_id is the Google Cloud Project ID to use for the Cloud Dataproc Serverless.
* bucket_name is the URI of a bucket where the main python file of the workload (spark-job.py) is located.
* phs_cluster is the Persistent History Server cluster name.
* image_name is the name and tag of the custom container image (image:tag).
* metastore_cluster is the Dataproc Metastore service name.
* region_name is the region where the Dataproc Metastore service is located.
"""

import datetime

from airflow import models
from airflow.providers.google.cloud.operators.dataproc import (
    DataprocSubmitJobOperator
)
from airflow.utils.dates import days_ago

PROJECT_ID = "{{ var.value.project_id }}"
REGION = "{{ var.value.region_name}}"
BUCKET = "{{ var.value.bucket_name }}"
DATAPROC_CLUSTER = "{{ var.value.phs_cluster }}"

JOB_FILE_URI = "gs://{{var.value.bucket_name }}/spark-job.py"

PYSPARK_JOB = {
    "reference": {"project_id": PROJECT_ID},
    "placement": {"cluster_name": DATAPROC_CLUSTER},
    "pyspark_job": {"main_python_file_uri": JOB_FILE_URI,
                    "properties":
                        {
                            "spark.driver.memory": "2g",
                            "spark.executor.memory": "2g",
                            "spark.executor.instances": "2"
                        }
                    },

}


default_args = {
    # Tell airflow to start one day ago, so that it runs as soon as you upload it
    "start_date": days_ago(1),
    "project_id": PROJECT_ID,
    "region": REGION,
}
with models.DAG(
        "dataproc_job",  # The id you will see in the DAG airflow page
        default_args=default_args,  # The interval with which to schedule the DAG
        schedule_interval=datetime.timedelta(days=1),  # Override to match your needs
) as dag:
    pyspark_task = DataprocSubmitJobOperator(
        task_id="pyspark_task", job=PYSPARK_JOB
    )
    pyspark_task

    # [END composer_dataproc_create_metastore_batch]
