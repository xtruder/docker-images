# fuse-overlayfs-dind (xtruder/docker:dind-latest)

docker-in-docker image with fuse-overlayfs support

## About

Original image does not have fuse-overlayfs binary. This image adds fuse-overlayfs binary.

## Running

```
docker run -e DOCKER_DRIVER=fuse-overlayfs --privileged xtruder/docker:dind-latest
```