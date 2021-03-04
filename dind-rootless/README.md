# dind-rootless

[![image](https://img.shields.io/docker/v/xtruder/dind-rootless.svg)](https://hub.docker.com/r/xtruder/dind-rootless)

rootless docker-in-docker image with fuse-overlayfs support

## About

Original image does not have fuse-overlayfs binary. This image adds fuse-overlayfs binary.

## Running

```
docker run -e DOCKER_DRIVER=fuse-overlayfs --privileged xtruder/dind-rootless:latest
```

## docker-compose example

```yaml
version: '3'
services:
  docker:
    image: xtruder/dind-rootless:latest
    command: ["--insecure-registry=registry.kube-system.svc.cluster.local:5000"]
    environment:
      DOCKER_TLS_CERTDIR: ""
      DOCKER_DRIVER: fuse-overlayfs
    volumes:
      - docker:/var/lib/docker
    privileged: yes
    security_opt:
      - label:disable
    network_mode: bridge
volumes:
  docker:
```