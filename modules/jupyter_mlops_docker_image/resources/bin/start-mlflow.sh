#!/usr/bin/env bash

MLFLOW_UI_PORT=5000

set -x

export MFLOW_HOME=$HOME/mlflow

mkdir -p $MFLOW_HOME/experiments

source /opt/conda/etc/profile.d/conda.sh

mlflow db upgrade sqlite:///${MFLOW_HOME}/experiments/mlflow.db
mlflow server --host 0.0.0.0 --port $MLFLOW_UI_PORT \
--default-artifact-root ${MFLOW_HOME}/artifacts \
--backend-store-uri sqlite:///${MFLOW_HOME}/experiments/mlflow.db &