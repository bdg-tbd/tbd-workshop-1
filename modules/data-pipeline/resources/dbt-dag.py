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

# [START composer_2_kubernetespodoperator]
"""Example DAG using KubernetesPodOperator."""
import datetime

from airflow import models
from airflow.kubernetes.secret import Secret
from airflow.providers.cncf.kubernetes.operators.kubernetes_pod import (
    KubernetesPodOperator,
)
from kubernetes.client import models as k8s_models


YESTERDAY = datetime.datetime.now() - datetime.timedelta(days=1)

# If a Pod fails to launch, or has an error occur in the container, Airflow
# will show the task as failed, as well as contain all of the task logs
# required to debug.
with models.DAG(
        dag_id="composer_sample_dbt_task",
        schedule_interval=datetime.timedelta(days=1),
        start_date=YESTERDAY,
) as dag:
    # Only name, namespace, image, and task_id are required to create a
    # KubernetesPodOperator. In Cloud Composer, currently the operator defaults
    # to using the config file found at `/home/airflow/composer_kube_config if
    # no `config_file` parameter is specified. By default it will contain the
    # credentials for Cloud Composer's Google Kubernetes Engine cluster that is
    # created upon environment creation.
    # [START composer_2_kubernetespodoperator_minconfig]
    kubernetes_min_pod = KubernetesPodOperator(
        # The ID specified for the task.
        task_id="dbt-task",
        # Name of task you want to run, used to generate Pod ID.
        name="dbt-task",
        labels={"app": "dbt-app"},
        # Entrypoint of the container, if not specified the Docker container's
        # entrypoint is used. The cmds parameter is templated.
        image_pull_policy="Always",
        cmds=["bash", "-c"],
        arguments=["git clone {{ var.value.dbt_git_repo}} && cd tbd-tpc-di && git checkout {{ var.value.dbt_git_repo_branch }}" 
                   "&& dbt deps && dbt run"],
        # The namespace to run within Kubernetes. In Composer 2 environments
        # after December 2022, the default namespace is
        # `composer-user-workloads`.
        namespace="{{ var.value.wrk_namespace }}",
        # Docker image specified. Defaults to hub.docker.com, but any fully
        # qualified URLs will point to a custom repository. Supports private
        # gcr.io images if the Composer Environment is under the same
        # project-id as the gcr.io images and the service account that Composer
        # uses has permission to access the Google Container Registry
        # (the default service account has permission)
        image="eu.gcr.io/{{ var.value.project_id }}/dbt:1.7.13",
        # Specifies path to kubernetes config. If no config is specified will
        # default to '~/.kube/config'. The config_file is templated.
        config_file="/home/airflow/composer_kube_config",
        # Identifier of connection that should be used
        kubernetes_conn_id="kubernetes_default",
        env_vars={"HADOOP_CONF_DIR": "/etc/hadoop/conf"},
        container_resources={
            'request_memory': '2048M',
            'limit_memory': '4096M',
            'request_cpu': '800m',
            'limit_cpu': '1000m'
        }
    )
    # [END composer_2_kubernetespodoperator_minconfig]
    # [START composer_2_kubernetespodoperator_templateconfig]