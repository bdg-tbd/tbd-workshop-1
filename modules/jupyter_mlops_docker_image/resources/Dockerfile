FROM gcr.io/deeplearning-platform-release/base-cpu.py310:m108
ARG JUPYTERLAB_VERSION
ARG PROJECT_NAME
ARG HADOOP_CONF_DIR=/etc/hadoop/conf
ARG SPARK_VERSION
ARG GCS_CONNECTOR_VERSION
ARG DBT_VERSION
ARG DBT_SPARK_VERSION
ARG MLFLOW_VERSION
ARG KEDRO_VERSION
ARG VS_CODE_VERSION

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
RUN /opt/conda/bin/pip install --no-cache-dir \
        jupyterlab==$JUPYTERLAB_VERSION \
        pyspark==$SPARK_VERSION \
        mlflow==$MLFLOW_VERSION \
        dbt-core==$DBT_VERSION \
        dbt-spark==$DBT_SPARK_VERSION \
        kedro==$KEDRO_VERSION \
        jupyter-server-proxy==4.1.2 \
        jupyter-ai==2.15.0 \
        langchain-openai==0.1.6 \
        kedro-mlflow==0.12.2 \
        kedro-viz

# Jupyterlab Shortcuts
RUN cd /tmp && \
    git clone https://github.com/tristanlt/jupyter-launcher-shortcuts.git && \
    cd jupyter-launcher-shortcuts && \
    git checkout 1d07be1f4eebe9e8bea86edc3c1567270e73face && \
    /opt/conda/bin/pip install -e .

# VS Code Server
RUN cd /opt/ && wget https://github.com/cdr/code-server/releases/download/v${VS_CODE_VERSION}/code-server_${VS_CODE_VERSION}_amd64.deb && \
    wget --quiet https://github.com/cdr/code-server/releases/download/v${VS_CODE_VERSION}/code-server-${VS_CODE_VERSION}-linux-amd64.tar.gz && \
    tar zxvf code-server-${VS_CODE_VERSION}-linux-amd64.tar.gz

RUN /opt/code-server-*-linux-amd64/bin/code-server \
    --extensions-dir /tmp/$NB_USER/extensions \
    --user-data-dir /tmp/$NB_USER/data \
    --config /tmp/$NB_USER/config.yaml \
    --install-extension ms-python.python \
    --install-extension Continue.continue


RUN mkdir -p /opt/tools/bin && mkdir -p /opt/tools/logos && chmod -R 755 /opt/tools/
COPY bin/*.sh /opt/tools/bin/
COPY logos/* /opt/tools/logos/

COPY jupyter_notebook_config.py /opt/google/jupyter/jupyter_notebook_config.py
COPY jupyter_notebook_config.py /opt/jupyter/.jupyter/jupyter_notebook_config.py

RUN mkdir -p $HADOOP_CONF_DIR
COPY conf/* $HADOOP_CONF_DIR
ENV HADOOP_CONF_DIR=$HADOOP_CONF_DIR
RUN wget -q -O /home/jupyter/gcs-connector-hadoop3-${GCS_CONNECTOR_VERSION}-shaded.jar https://repo1.maven.org/maven2/com/google/cloud/bigdataoss/gcs-connector/hadoop3-${GCS_CONNECTOR_VERSION}/gcs-connector-hadoop3-${GCS_CONNECTOR_VERSION}-shaded.jar
ENV PYSPARK_DRIVER_PYTHON=/usr/bin/python3.8
EXPOSE 8080 16384 16385 4040
