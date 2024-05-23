FROM gcr.io/deeplearning-platform-release/base-cpu.py310:m108
ARG JUPYTERLAB_VERSION
ARG PROJECT_NAME
ARG HADOOP_CONF_DIR=/etc/hadoop/conf
ARG SPARK_VERSION
ARG GCS_CONNECTOR_VERSION
ARG DBT_VERSION
ARG DBT_SPARK_VERSION
ARG VS_CODE_VERSION
ENV MLFLOW_ENABLED=true
ENV VS_CODE_ENABLED=true

#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
# to remove to make this image run as non-root user
#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"
RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    pipx \
    git \
    make \
    openjdk-11-jdk \
    jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV PATH=/usr/bin:/usr/local/bin:$PATH
## use JUPYTERLAB_VERSION to pin jupyterlab version
#FIXME:unpin jupyterlab version
RUN wget --quiet https://bootstrap.pypa.io/get-pip.py && python3.8 get-pip.py
RUN pip3 install --no-cache-dir \
        jupyterlab==$JUPYTERLAB_VERSION \
        pyspark==$SPARK_VERSION \
        mlflow==2.3.0 \
        dbt-core==$DBT_VERSION \
        dbt-spark==$DBT_SPARK_VERSION
RUN mkdir -p $HADOOP_CONF_DIR
COPY conf/* $HADOOP_CONF_DIR
ENV HADOOP_CONF_DIR=$HADOOP_CONF_DIR
RUN wget -q -O /home/jupyter/gcs-connector-hadoop3-${GCS_CONNECTOR_VERSION}-shaded.jar https://repo1.maven.org/maven2/com/google/cloud/bigdataoss/gcs-connector/hadoop3-${GCS_CONNECTOR_VERSION}/gcs-connector-hadoop3-${GCS_CONNECTOR_VERSION}-shaded.jar
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python3.8
EXPOSE 8080 16384 16385 4040
