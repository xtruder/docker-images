FROM fedora:35

RUN dnf install -y dnf-plugins-core
RUN dnf config-manager --add-repo https://proxsign.setcce.si/proxsign/repo/proxsign-fedora.repo
RUN dnf install -y proxsign socat

RUN useradd -u 1000 -ms /bin/bash proxsign

USER proxsign
WORKDIR /home/proxsign
VOLUME /home/proxsign

# vnc
EXPOSE 5900/tcp

# proxsign
EXPOSE 14972/tcp

ENV QT_QPA_PLATFORM=vnc

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
