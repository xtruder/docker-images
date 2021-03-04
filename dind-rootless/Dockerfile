FROM docker:dind-rootless

ARG fuse_overlayfs_binary_url=https://github.com/containers/fuse-overlayfs/releases/download/v1.4.0/fuse-overlayfs-x86_64

# set user to root to download binary
USER root
RUN wget -O /usr/bin/fuse-overlayfs $fuse_overlayfs_binary_url && chmod +x /usr/bin/fuse-overlayfs

# reset user to 1000
USER 1000