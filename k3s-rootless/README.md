# k3s-rootless

[![image](https://img.shields.io/docker/v/xtruder/k3s-rootless.svg)](https://hub.docker.com/r/xtruder/k3s-rootless)

k3s image with fixed rootless support and fuse-overlayfs.

## About

Original k3s image does not have unprivileged user and does not have fuse support
for fuse-overlayfs snapshotter to work. This image extends original image to
add unprivileged user and adds fuse support.

For github issue that this image is based on see: https://github.com/k3s-io/k3s/issues/2054

## Running

```
docker run --privileged xtruder/k3s-rootless \
    server --rootless --snapshotter fuse-overlayfs --data-dir /var/lib/rancher/k3s-rootless
```

## docker-compose example

```yaml
version: '3'
services:
  k3s:
    image: xtruder/k3s-rootless:latest
    command: server --rootless --snapshotter fuse-overlayfs --data-dir /var/lib/rancher/k3s-rootless
    environment:
    - K3S_NODE_NAME=k3s
    - K3S_TOKEN=${K3S_TOKEN:-29338293525080}
    - K3S_KUBECONFIG_OUTPUT=/output/kubeconfig.yaml
    - K3S_KUBECONFIG_MODE=666
    volumes:
    - k3s-server:/var/lib/rancher/k3s-rootless
    # This is just so that we get the kubeconfig file out
    - kubeconfig:/output
    privileged: true
    security_opt:
      - label:disable
    sysctls:
      - net.ipv4.ip_forward=1
    network_mode: bridge
volumes:
  k3s-server:
  kubeconfig:
```