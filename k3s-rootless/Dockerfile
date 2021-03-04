FROM alpine:3.13 AS alpine
RUN apk -u --no-cache add shadow-uidmap fuse3

FROM rancher/k3s:v1.20.4-k3s1

COPY --from=alpine /etc/passwd /etc/group /etc/shadow /etc/subgid /etc/subuid /etc/
COPY --from=alpine /usr/bin/newgidmap /usr/bin/newuidmap /usr/sbin/mount.fuse3 /usr/bin/
COPY --from=alpine /usr/lib/libfuse3.so.3 /usr/lib/
COPY --from=alpine /lib/ld-musl-x86_64.so.1 /lib/

# create k3s user with home at /var/lib/rancher/k3s-rootless
RUN mkdir -p /var/lib/rancher/k3s-rootless \
        && adduser -h /var/lib/rancher/k3s-rootless -g k3s -s /bin/false -D -u 1000 -G root k3s \
        && echo k3s:165536:65536 >> /etc/subuid \
        && echo k3s:165536:65536 >> /etc/subgid

# volume already exists at /var/lib/rancher/k3s, so use /var/lib/rancher/k3s-rootless instead
VOLUME /var/lib/rancher/k3s-rootless

# make /bin/aux writable, so k3s can symlink files here
RUN chmod g+w /bin/aux

# set machine-id to some value
RUN echo F3F79821-80EE-4B43-A4DD-E3DA712CA2BC >/etc/machine-id

# /var/run needs to be writable by k3s
RUN chown k3s:root /var/run

# create directory and volume to output kubeconfig
RUN mkdir -p /output && chown k3s:root /output
VOLUME /output

USER k3s:root