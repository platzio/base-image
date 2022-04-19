FROM ubuntu:latest

ARG TIMEZONE=Etc/UTC
RUN ln -fs "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    gnupg2 \
    libpq5 \
    wget \
    unzip

RUN cd `mktemp -d` && \
    wget https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get-helm-3 && \
    DEBUG=true USE_SUDO=false DESIRED_VERSION=v3.6.3 ./get-helm-3

RUN apt-get install -y curl && \
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

RUN mkdir -p /tmp/awscli2 && \
    cd /tmp/awscli2 && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf /tmp/awscli2

WORKDIR /root/

CMD ["/bin/bash"]
