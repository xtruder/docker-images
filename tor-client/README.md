# [tor-client](https://github.com/xtruder/docker-images/pkgs/container/tor-client)

[![workflow status](https://github.com/xtruder/docker-images/actions/workflows/tor-client.yml/badge.svg)](https://github.com/xtruder/docker-images/pkgs/container/tor-client)

tor client running inside docker exposing socks and dns ports with nyx tui

## About

Sometimes you need a TOR client that you can just run and use as socks server.
This is minimal rootless alpine based image with tor and nyx installed.

## Running

```
docker run --name tor -p 9050:9050 ghcr.io/xtruder/tor-client:latest
```

To control tor you can exec into container and run nyx:

```
docker exec -ti tor nyx
```

### Example with volumes for /var/run/tor and /var/lib/tor


```
docker run -d --name tor \
    -v runtor:/var/run/tor \
    -v libtor:/var/lib/tor \
    -p 9050:9050 \
    ghcr.io/xtruder/tor-client:latest
```

### Docker compose based VPN example using tun2socks

```yaml
version: '3'
services:
  tor-client:
    image: ghcr.io/xtruder/tor-client:latest
    container_name: tor-client
    expose:
      - 9050/tcp
      - 9051/tcp
      - 53/udp
      - 53/tcp
    volumes:
      - libtor:/var/lib/tor:rw
    security_opt:
      - label:disable
    networks:
      torvpn:
        ipv4_address: 172.20.128.2

  torvpn:
    image: xjasonlyu/tun2socks
    container_name: torvpn
    environment:
      PROXY: socks5://172.20.128.2:9050
      TUN_EXCLUDED_ROUTES: 172.20.0.0/16 
    depends_on:
      - tor-client
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    networks:
      torvpn:
        ipv4_address: 172.20.128.3

volumes:
  libtor:

networks:
  torvpn:
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

To use a network namespace of `torvpn` container you can use `--net container:tor` vpn option
or `network_mode: container:torvpn` docker-compose option.

```
docker run -ti --net container:torvpn alpine:edge
```

You will also probably wany to override `resolv.conf` to use tor's dns server. You can do that
by mounting volume with `resolv.conf` file in container using `-v $PWD/resolv.conf:/etc/resolv.conf`
and content:

```
nameserver 172.20.128.2
options edns0 trust-ad ndots:0
```