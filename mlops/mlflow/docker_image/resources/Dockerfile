#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
# to remove to make this image run as non-root user
#checkov:skip=CKV_DOCKER_3: "Ensure that a user for the container has been created"
#checkov:skip=CKV_DOCKER_4: "Ensure that COPY is used instead of ADD in Dockerfiles"
FROM google/cloud-sdk:426.0.0
ARG MLFLOW_VERSION

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN echo "export LC_ALL=$LC_ALL" >> /etc/profile.d/locale.sh
RUN echo "export LANG=$LANG" >> /etc/profile.d/locale.sh

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

RUN pip3 install --no-cache-dir --ignore-installed google-cloud-storage==2.9.0 && \
    pip3 install --no-cache-dir PyMySQL==1.0.3 \
                                mlflow==$MLFLOW_VERSION \
                                pyarrow==11.0.0

WORKDIR "/"
COPY start.sh start.sh
RUN chmod +x start.sh


ENTRYPOINT ["/tini", "--", "./start.sh"]
