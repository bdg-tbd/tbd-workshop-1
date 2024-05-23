#!/usr/bin/env bash

export VERTEX_IMAGE_NAME=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.Image'`
export VERTEX_CONTAINER_NAME=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.Names'`
export VERTEX_CONTAINER_ID=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.ID'`
export VERTEX_CONTAINER_HOSTNAME=`hostname -f`
export VERTEX_CONTAINER_IP=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${VERTEX_CONTAINER_ID}`
export GCS_CONNECTOR_VERSION=2.2.17
export PYSPARK_SUBMIT_ARGS="--packages com.databricks:spark-xml_2.12:0.17.0 --conf spark.executor.instances=3 --conf spark.executor.memory=2g --conf spark.sql.legacy.timeParserPolicy=LEGACY --jars /home/jupyter/gcs-connector-hadoop3-${GCS_CONNECTOR_VERSION}-shaded.jar --master yarn --conf spark.hadoop.fs.gs.impl=com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem --conf spark.hadoop.fs.AbstractFileSystem.gs.impl=com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS --conf spark.driver.port=16384 --conf spark.driver.blockManager.port=16385 --conf spark.driver.bindAddress=${VERTEX_CONTAINER_IP} --conf spark.driver.host=${VERTEX_CONTAINER_HOSTNAME} pyspark-shell"
export NOTEBOOK_IP=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${VERTEX_CONTAINER_ID}`
sudo docker stop $VERTEX_CONTAINER_ID && sudo docker rm $VERTEX_CONTAINER_ID
# FIXME: below settings are not persistent - once you stop the Notebook or restart the container, you will lose them
# There are options of hacking the startup script that are executed at boot to make them persistent, but it's not recommended
sudo docker run -d \
    -e PYSPARK_SUBMIT_ARGS="${PYSPARK_SUBMIT_ARGS}" \
    -e MLFLOW_ENABLED="true" \
    -e VS_CODE_ENABLED="true" \
    -p 8080:8080 \
    -p 16384:16384 \
    -p 16385:16385 \
    -p 4040:4040 \
    --name $VERTEX_CONTAINER_NAME $VERTEX_IMAGE_NAME

sleep 30s
sudo docker exec -it $VERTEX_CONTAINER_NAME python3.8 -m ipykernel install --user --name pyspark
