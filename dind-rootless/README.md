# dind-rootless

[![image](https://img.shields.io/docker/v/xtruder/dind-rootless.svg)](https://hub.docker.com/r/xtruder/dind-rootless)

rootless docker-in-docker image with fuse-overlayfs support

## About

Original image does not have fuse-overlayfs binary. This image adds fuse-overlayfs binary.

## Running

```
docker run -e DOCKER_DRIVER=fuse-overlayfs --privileged xtruder/dind-rootless:latest
```