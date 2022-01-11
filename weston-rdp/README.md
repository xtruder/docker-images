# weston-rdp

Weston wayland compositor running in container via RDP backend.

## About

Sometimes you want to run GUI applications in your development containers.
Using weston wayland compositor is a simple way to make it work, as it provides
wayland, desktop and RDP all in a single package. Sharing a wayland socket with
sidecontainer is also easy.

## Running

```
docker run -ti -p 3389:3389 weston-rdp
```