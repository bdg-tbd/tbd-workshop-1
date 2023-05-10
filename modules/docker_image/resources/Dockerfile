FROM gcr.io/deeplearning-platform-release/base-cpu.py310:m108
ARG JUPYTERLAB_VERSION
ARG HADOOP_CONF_DIR=/etc/hadoop/conf
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

## use JUPYTERLAB_VERSION to pin jupyterlab version
#FIXME:unpin jupyterlab version
RUN pip3 install --no-cache-dir \
        jupyterlab==$JUPYTERLAB_VERSION \
        pyspark==3.3.2
RUN mkdir -p $HADOOP_CONF_DIR
COPY conf/* $HADOOP_CONF_DIR
ENV HADOOP_CONF_DIR=$HADOOP_CONF_DIR