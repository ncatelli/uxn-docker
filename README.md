# uxn-docker

## Description

A container for running [uxn](https://100r.co/site/uxn.html) over a browser-based vnc session.

## Building

```bash
docker build -t uxn:latest .
```

## Running

```bash
docker run --rm -it -p 6080:6080 uxn:latest
```

### Accesssing
A VNC console will be made available at http://localhost:6080/vnc.html.

Essentials, roms are installed at `/home/uxn/roms`.
All uxn binaries are available in /usr/local/bin/ and are available in the PATH.

## Thanks
https://github.com/theasp/docker-novnc/ for a referenceable approach for novnc.