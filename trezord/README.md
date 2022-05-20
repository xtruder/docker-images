# [trezor-bridge](https://github.com/xtruder/docker-images/pkgs/container/trezord)

[![workflow status](https://github.com/xtruder/docker-images/actions/workflows/trezord.yml/badge.svg)](https://github.com/xtruder/docker-images/pkgs/container/trezord)

minimal alpine based docker container running [trezord-go](https://github.com/trezor/trezord-go)

## Running

```
docker run --net=host --privileged -v /dev/bus/usb:/dev/bus/usb ghcr.io/xtruder/trezord:latest
```

This will start trezor daemon with api server listening on `localhost:21325`.

You can test whether api works correctly by executing into container and running:

```
curl -H "Origin: https://wallet.trezor.io"  -v localhost:21325/enumerate -XPOST
```

This will enumerate currently connected trezor devices.