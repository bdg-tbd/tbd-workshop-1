#checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
FROM gitpod/openvscode-server:1.79.2
ENV OPENVSCODE_SERVER_ROOT="/home/.openvscode-server"
ENV OPENVSCODE="${OPENVSCODE_SERVER_ROOT}/bin/openvscode-server"
ARG MINICONDA_ROOT=/opt/miniconda3
USER root
# Terraform
RUN apt-get update && \
    apt-get install -y --no-install-recommends gnupg software-properties-common wget && \
    wget -q -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && apt-get install -y --no-install-recommends terraform  && \
    rm -rf /var/lib/apt/lists/*

# gcloud
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-cli -y --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# miniconda 3.10
RUN mkdir -p $MINICONDA_ROOT && \
    wget -q https://repo.anaconda.com/miniconda/Miniconda3-py310_23.3.1-0-Linux-x86_64.sh -O $MINICONDA_ROOT/miniconda.sh && \
    bash $MINICONDA_ROOT/miniconda.sh -b -u -p $MINICONDA_ROOT && \
    rm -rf $MINICONDA_ROOT/miniconda.sh && \
    $MINICONDA_ROOT/bin/conda init bash && \
    $MINICONDA_ROOT/bin/conda init zsh

ENV PATH=$PATH:$MINICONDA_ROOT/bin

# gsutil
RUN pip3 install --no-cache-dir gsutil==5.24

# pre-commit deps
RUN pip3 install --no-cache-dir pre-commit==3.3.3 checkov==2.3.294

RUN apt-get update -y && apt-get install unzip -y --no-install-recommends && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN curl -L "$(curl -s https://api.github.com/repos/terraform-docs/terraform-docs/releases/latest | grep -o -E -m 1 "https://.+?-linux-amd64.tar.gz")" > terraform-docs.tgz && tar -xzf terraform-docs.tgz terraform-docs && rm terraform-docs.tgz && chmod +x terraform-docs && mv terraform-docs /usr/bin/
RUN curl -L "$(curl -s https://api.github.com/repos/tenable/terrascan/releases/latest | grep -o -E -m 1 "https://.+?_Linux_x86_64.tar.gz")" > terrascan.tar.gz && tar -xzf terrascan.tar.gz terrascan && rm terrascan.tar.gz && mv terrascan /usr/bin/ && terrascan init
RUN curl -L "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.zip")" > tflint.zip && unzip tflint.zip && rm tflint.zip && mv tflint /usr/bin/
RUN curl -L "$(curl -s https://api.github.com/repos/aquasecurity/tfsec/releases/latest | grep -o -E -m 1 "https://.+?tfsec-linux-amd64")" > tfsec && chmod +x tfsec &&  mv tfsec /usr/bin/
RUN apt-get update -y && apt-get install -y --no-install-recommends jq && apt-get clean && rm -rf /var/lib/apt/lists/* && \
    curl -L "$(curl -s https://api.github.com/repos/minamijoyo/tfupdate/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.tar.gz")" > tfupdate.tar.gz && tar -xzf tfupdate.tar.gz tfupdate && rm tfupdate.tar.gz && mv tfupdate /usr/bin/ && \
    curl -L "$(curl -s https://api.github.com/repos/minamijoyo/hcledit/releases/latest | grep -o -E -m 1 "https://.+?_linux_amd64.tar.gz")" > hcledit.tar.gz && tar -xzf hcledit.tar.gz hcledit && rm hcledit.tar.gz && mv hcledit /usr/bin/

# hadolint
RUN wget -q https://github.com/hadolint/hadolint/releases/download/v2.12.1-beta/hadolint-Linux-x86_64 && \
    mv hadolint-Linux-x86_64 /usr/bin/hadolint && \
    chmod +x /usr/bin/hadolint

# docker
RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN usermod -aG docker openvscode-server
USER openvscode-server

SHELL ["/bin/bash", "-c"]
RUN \
    # Direct download links to external .vsix not available on https://open-vsx.org/
    # The two links here are just used as example, they are actually available on https://open-vsx.org/
    urls=(\
        https://open-vsx.org/api/hashicorp/terraform/linux-x64/2.26.1/file/hashicorp.terraform-2.26.1@linux-x64.vsix \
        https://open-vsx.org/api/exiasr/hadolint/1.1.2/file/exiasr.hadolint-1.1.2.vsix \
        https://open-vsx.org/api/ms-python/python/2023.10.1/file/ms-python.python-2023.10.1.vsix \
        https://open-vsx.org/api/ms-toolsai/jupyter/2023.4.1001091014/file/ms-toolsai.jupyter-2023.4.1001091014.vsix \
        https://open-vsx.org/api/shd101wyy/markdown-preview-enhanced/0.6.8/file/shd101wyy.markdown-preview-enhanced-0.6.8.vsix \
        https://open-vsx.org/api/eamodio/gitlens/14.0.0/file/eamodio.gitlens-14.0.0.vsix \
    )\
    # Create a tmp dir for downloading
    && tdir=/tmp/exts && mkdir -p "${tdir}" && cd "${tdir}" \
    # Download via wget from $urls array.
    && wget "${urls[@]}" && \
    # List the extensions in this array
    exts=(\
        # From https://open-vsx.org/ registry directly
        gitpod.gitpod-theme \
        # From filesystem, .vsix that we downloaded (using bash wildcard '*')
        "${tdir}"/* \
    )\
    # Install the $exts
    && for ext in "${exts[@]}"; do ${OPENVSCODE} --install-extension "${ext}"; done
