FROM ubuntu:latest

ARG TIMEZONE=Etc/UTC
RUN ln -fs "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    awscli \
    ca-certificates \
    gnupg2 \
    libpq5 \
    wget

RUN cd `mktemp -d` && \
    wget https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get-helm-3 && \
    DEBUG=true USE_SUDO=false DESIRED_VERSION=v3.6.3 ./get-helm-3

RUN apt-get install -y curl && \
    curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install -y kubectl

WORKDIR /root/

CMD ["/bin/bash"]
