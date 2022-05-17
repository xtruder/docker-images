# [kali-desktop](https://github.com/xtruder/docker-images/pkgs/container/kali-desktop)

[![workflow status](https://github.com/xtruder/docker-images/actions/workflows/kali-desktop.yml/badge.svg)](https://github.com/xtruder/docker-images/pkgs/container/kali-desktop)

Kali desktop image

**Tags:**

- `latest`, `kali-linux-default`: kali desktop with `kali-linux-default` meta package
- `kali-linux-core`: kali desktop with `kali-linux-core` metapackage

## Examples

```
docker run --rm -ti  -p 3389:3389  --cap-add NET_BIND_SERVICE ghcr.io/xtruder/kali-desktop:kali-linux-default
```

## docker-compose example

```yaml
version: '3'
services:
  desktop:
    image: xtruder/kali-desktop:latest
    cap_add:
      - NET_ADMIN
      - NET_BIND_SERVICE
    security_opt:
      - label:disable
    network_mode: "bridge"
```
