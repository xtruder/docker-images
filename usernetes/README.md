# usernetes

![workflow status](https://github.com/xtruder/docker-images/actions/workflows/usernetes.yml/badge.svg)

Usernetes running in docker, with required changes to export kubeconfig.

## docker-compose example

```yaml
version: '3'
services:
  usernetes:
    image: ghcr.io/xtruder/usernetes:latest
    tty: true
    privileged: true
    command: --cri=containerd
    volumes:
      - usernetes-config:/home/user/.config/usernetes
      - usernetes-data:/home/user/.local
    hostname: "usernetes"
    network_mode: "bridge"

volumes:
  usernetes-config:
  usernetes-data:
```