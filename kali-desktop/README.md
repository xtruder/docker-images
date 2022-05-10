# kali-desktop

![workflow status](https://github.com/xtruder/docker-images/actions/workflows/kali-desktop.yml/badge.svg)

Kali desktop image

## docker-compose example

```yaml
version: '3'
services:
  desktop:
    image: xtruder/kali-desktop:latest
    environment:
      RESOLUTION: 1920x1024x24
    cap_add:
      - NET_ADMIN
      - NET_BIND_SERVICE
    security_opt:
      - label:disable
    network_mode: "bridge"
```
