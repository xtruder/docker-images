FROM docker.io/library/alpine:edge AS docker_xnoshm

RUN apk add --no-cache gcc musl-dev libxext-dev

COPY docker_xnoshm.c /
RUN gcc /docker_xnoshm.c -shared -nostdlib -o /docker_xnoshm.so

FROM docker.io/library/alpine:edge

# Add packages
RUN apk add --no-cache \
    weston weston-backend-rdp weston-shell-desktop weston-terminal weston-xwayland \
    xwayland freerdp terminus-font adwaita-icon-theme xterm tini

# Install xnoshm hack
COPY --from=docker_xnoshm /docker_xnoshm.so /usr/lib/docker_xnoshm.so
ENV LD_PRELOAD="/usr/lib/docker_xnoshm.so"

# Create user and groups
RUN addgroup -S -g 1000 weston && \
    adduser -S -u 1000 -h /run/weston -G weston weston && \
    chmod 0700 /run/weston

# Create /etc/weston and generate certs
RUN mkdir -p /etc/weston && \
    winpr-makecert -rdp -path /etc/weston cert && \
    chown -R weston:weston /etc/weston

# Copy weston config
COPY weston.ini /etc/xdg/weston/weston.ini

# Create /tmp/.X11-unix, Xwayland fails without it
RUN mkdir /tmp/.X11-unix && chown weston:weston /tmp/.X11-unix

# XDG_RUNTIME_DIR must be set, so weston knows where to place wayland sockets
ENV XDG_RUNTIME_DIR=/run/weston

WORKDIR /run/weston
USER weston

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["weston", "--rdp-tls-cert=/etc/weston/cert.crt", "--rdp-tls-key=/etc/weston/cert.key"]

EXPOSE 3389

# onbuild uid and gid fixes
ONBUILD USER root
ONBUILD ARG USER_UID=1000
ONBUILD ARG USER_GID=${USER_UID}
ONBUILD RUN \
    set -x && \
    if [ "$(id -u weston)" != "${USER_UID}" ] || [ "$(id -g weston)" != "${USER_GID}" ]; then \
        apk add shadow && \
        groupmod -g ${USER_GID} weston || true && \
        usermod -u ${USER_UID} -g ${USER_GID} weston && \
        chown ${USER_UID}:${USER_GID} /run/weston /tmp/.X11-unix; \
    fi
ONBUILD USER weston
