FROM ubuntu:22.04
#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
# to remove to make this image run as non-root user
#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"

RUN apt-get -y update && \
    apt-get install -y --no-install-recommends \
    python3-pip \
    pipx \
    git \
    make \
    jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
        poetry==1.1.14 \
        jupyterlab==3.6.3

# Create a link that points to the right python bin directory
RUN ln -s /usr/bin/python3.10 /usr/bin/python