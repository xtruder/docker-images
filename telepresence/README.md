# telepresence

[![image](https://img.shields.io/docker/v/xtruder/telepresence.svg)](https://hub.docker.com/r/xtruder/telepresence)

telepresence running inside docker

## About

I wanted to connect to k3s cluster running inside docker-compose

## Running

```
docker run \
    --restart always --tty \
    -e SCOUT_DISABLE=1 \
    -e KUBECONFIG=/var/run/kubeconfig.yaml \
    -v kubeconfig.yaml:/var/run/kubeconfig.yaml \
    --cap-add NET_ADMIN --cap-add NET_BIND_SERVICE \
    xtruder/telepresence:latest --method vpn-tcp --namespace kube-system --run /bin/sleep inifinity
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
  teleperesence:
    image: xtruder/telepresence:latest  
    tty: true
    environment:
      SCOUT_DISABLE: "1"
      KUBECONFIG: /var/run/k3s-kubeconfig/kubeconfig.yaml
    command: ["--method", "vpn-tcp", "--namespace", "kube-system", "--run", "/bin/sleep", "infinity"]
    cap_add:
      - NET_ADMIN
      - NET_BIND_SERVICE
    volumes:
      - kubeconfig:/var/run/k3s-kubeconfig
    restart: always
    depends_on:
      - k3s
    network_mode: "service:k3s"
volumes:
  k3s-server:
  kubeconfig:
```