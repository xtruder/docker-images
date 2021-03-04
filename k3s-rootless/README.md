# k3s-rootless

k3s image with fixed rootless support and fuse-overlayfs.

## About

Original image does not have unprivileged user and does not have fuse support
for fuse-overlayfs snapshotter to work. This image extends original image to
add unprivileged user and adds fuse support.

For github issue that this image is based on see: https://github.com/k3s-io/k3s/issues/2054

## Running

```
docker run --privileged xtruder/k3s-rootless \
    server --rootless --snapshotter fuse-overlayfs --data-dir /var/lib/rancher/k3s-rootless
```