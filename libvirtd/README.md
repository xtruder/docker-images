# libvirtd

[![image](https://img.shields.io/docker/v/xtruder/libvirtd.svg)](https://hub.docker.com/r/xtruder/libvirtd)

libvirtd running inside docker

## About

Running libvirtd inside of a docker is a bit of a challenge and i didn't find any
existing images. It requires a system with kvm and tun support, but this should be
avalible on most of linux distro. If running inside virtualization, you must make
sure nested virtualization is enabled.
This image starts libvirtd listening on unix socket, as well as listening locally.
To access you will need to share volume with sock, or much better soltuion is to
connect over tcp.

This image is based on this gist: https://gist.github.com/kosyfrances/f8ffd9b76ff6285d60d1b1671c2aa8f6

## Running

```
docker run \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw --privileged ghcr.io/xtruder/libvirtd:latest
```

## docker-compose examples

### minikube example

An example how to run minikube with dockerized libvirtd

```yaml
version: '3'
services:
  dev:
    image: my-dev-image
    environment:
      VAGRANT_DEFAULT_PROVIDER: libvirt
      LIBVIRT_DEFAULT_URI: qemu+tcp://127.0.0.1:16509/system
      MINIKUBE_DRIVER: kvm2
      MINIKUBE_CONTAINER_RUNTIME: containerd
      MINIKUBE_KVM_QEMU_URI: qemu+tcp://127.0.0.1:16509/system
    volumes:
      - libvirt-lib:/var/lib/libvirt
      - libvirt:/run/libvirt
      - minikube:/home/code/.minikube
      - vagrant:/home/code/.vagrant.d
    network_mode: "service:libvirtd"
  libvirtd:
    image: ghcr.io/xtruder/libvirtd:latest
    restart: always
    privileged: true
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup:rw
      - libvirt:/run/libvirt
      - libvirt-lib:/var/lib/libvirt
      - libvirt-qemu:/var/lib/libvirt-qemu
    devices:
      - /dev/kvm
    network_mode: bridge

volumes:
  libvirt:
  libvirt-lib:
  libvirt-qemu:
  vagrant:
  minikube:
```
