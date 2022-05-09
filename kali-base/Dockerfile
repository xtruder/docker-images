FROM kalilinux/kali-bleeding-edge:latest

ARG USER=kali
ARG PASSWORD=kali

# update package repositories
RUN apt-get -y update

# install base packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq kali-linux-core locales && \
    apt-get autoremove -y && \
    apt-get clean

# configure locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8 
ENV LC_ALL C.UTF-8

# create non-root user
RUN useradd --create-home --shell /bin/bash --user-group --groups sudo ${USER} && \
    echo "$USER:$PASSWORD" | HOME=/home/${USER} chpasswd

# create /data volume owned by $USER
RUN mkdir /data && chown $USER:$USER /data
VOLUME /data

CMD ["/bin/bash"]
