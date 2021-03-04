FROM ubuntu:20.04

RUN apt update && apt install -y apt-transport-https gnupg2 curl

# add telepresence repositories
RUN curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | bash && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt update

# install telepresence and dependencies
RUN apt install -y --no-install-recommends telepresence kubectl iptables sudo

# set entrypoint to telepresence
ENTRYPOINT ["/usr/bin/telepresence"]