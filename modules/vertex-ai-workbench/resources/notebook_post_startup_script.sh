#!/usr/bin/env bash

export VERTEX_IMAGE_NAME=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.Image'`
export VERTEX_CONTAINER_NAME=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.Names'`
export VERTEX_CONTAINER_ID=`sudo docker ps --no-trunc --format='{{json .}}' | jq -r '.ID'`

sudo docker stop $VERTEX_CONTAINER_ID && sudo docker rm $VERTEX_CONTAINER_ID
sudo docker run -d \
    -p 8080:8080 \
    -p 16384:16384 \
    -p 16385:16385 \
    -p 4040:4040 \
    --name $VERTEX_CONTAINER_NAME $VERTEX_IMAGE_NAME
