FROM ubuntu:latest

ARG TARGETPLATFORM
ARG TIMEZONE=Etc/UTC
RUN ln -fs "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime

RUN apt-get update
RUN apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    libpq5 \
    wget \
    unzip

RUN mkdir /tmp/install-helm && \
    cd /tmp/install-helm && \
    wget https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod +x get-helm-3 && \
    DEBUG=true USE_SUDO=false DESIRED_VERSION=v3.15.3 ./get-helm-3 && \
    cd / && \
    rm -rf /tmp/install-helm

RUN mkdir /tmp/install-kubectl && \
    cd /tmp/install-kubectl && \
    KUBECTL_VERSION="$(curl -fLs https://dl.k8s.io/release/stable.txt)" && \
    curl -LOf "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM}/kubectl" && \
    curl -LOf "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/${TARGETPLATFORM}/kubectl.sha256" && \
    echo "$(cat kubectl.sha256) kubectl" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    cd / && \
    rm -rf /tmp/install-kubectl

RUN mkdir -p /tmp/awscli2 && \
    cd /tmp/awscli2 && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-$(uname -m).zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf /tmp/awscli2

WORKDIR /root/

CMD ["/bin/bash"]
