FROM xtruder/kali-default:latest

ARG KALI_DESKTOP=xfce

RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        curl sudo apt-transport-https gnupg \
        x11vnc xvfb novnc dbus-x11 \
        kali-desktop-${KALI_DESKTOP} firefox-esr && \
    apt-get clean

# install s6
ARG S6_OVERLAY_VERSION=2.2.0.3
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86.tar.gz /tmp/
RUN gunzip -c /tmp/s6-overlay-x86.tar.gz | tar -xhf - -C / && \
    rm -f /tmp/s6-overlay-x86.tar.gz && ls -la /bin
RUN apt-get install -y s6

COPY etc/ /etc

# export required env variables
ENV DISPLAY :1
ENV KALI_DESKTOP ${KALI_DESKTOP}
ENV DESKTOP_USER kali

EXPOSE 5900/tcp 6080/tcp
ENTRYPOINT ["/init"]