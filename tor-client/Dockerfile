FROM alpine:edge

RUN apk add --no-cache curl tor python3 py3-pip
RUN pip install nyx

ADD torrc /etc/tor/torrc

RUN mkdir -p /var/run/tor && chown tor /var/run/tor

VOLUME /var/lib/tor /var/run/tor
USER tor
CMD tor

EXPOSE 9050/tcp
EXPOSE 53/udp

HEALTHCHECK --interval=45s --timeout=15s --start-period=20s \
    CMD curl -s --socks5 127.0.0.1:9050 'https://check.torproject.org/' | grep -qm1 Congratulations

