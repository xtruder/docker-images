# libvirtd

[![image](https://img.shields.io/docker/v/xtruder/libvirtd.svg)](https://hub.docker.com/r/xtruder/libvirtd)

libvirtd running inside docker

## About

Running libvirtd inside of a docker is a bit of a challenge and i didn't find any
existing images. It requires a system with kvm and tun support, but this should be
avalible on most of linux distro.
This image starts libvirtd listening on unix socket, as well as listening locally.
To access you will need to share volume with sock, or much better soltuion is to
connect over tcp.

This image is based on this gist: https://gist.github.com/kosyfrances/f8ffd9b76ff6285d60d1b1671c2aa8f6

## Running

```
docker run \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw --cap-add SYS_ADMIN --cap-add SYS_NICE --cap-add NET_ADMIN \
  xtruder/libvirtd
```

## docker-compose example

```yaml
```