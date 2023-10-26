#!/usr/bin/env bash

export VERTEX_IMAGE_NAME=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.Image'`
export VERTEX_CONTAINER_NAME=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.Names'`
export VERTEX_CONTAINER_ID=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.ID'`
export VERTEX_CONTAINER_HOSTNAME=`hostname -f`
export VERTEX_CONTAINER_IP=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${VERTEX_CONTAINER_ID}`

export PYSPARK_SUBMIT_ARGS="--conf spark.driver.port=16384 --conf spark.driver.blockManager.port=16385 --conf spark.driver.bindAddress=${VERTEX_CONTAINER_IP} --conf spark.driver.host=${VERTEX_CONTAINER_HOSTNAME} pyspark-shell"
export NOTEBOOK_IP=`sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' ${VERTEX_CONTAINER_ID}`
sudo docker stop $VERTEX_CONTAINER_ID && sudo docker rm $VERTEX_CONTAINER_ID
sudo docker run -d \
    -e PYSPARK_SUBMIT_ARGS="${PYSPARK_SUBMIT_ARGS}" \
    -p 8080:8080 \
    -p 16384:16384 \
    -p 16385:16385 \
    -p 4040:4040 \
    --name $VERTEX_CONTAINER_NAME $VERTEX_IMAGE_NAME

sleep 30s
sudo docker exec -it $VERTEX_CONTAINER_NAME python3.8 -m ipykernel install --user --name pyspark
