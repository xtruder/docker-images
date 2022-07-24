# [FreePBX](https://github.com/xtruder/docker-images/pkgs/container/freepbx)

[![workflow status](https://github.com/xtruder/docker-images/actions/workflows/freepbx.yml/badge.svg)](https://github.com/xtruder/docker-images/pkgs/container/freepbx)

FreePBX docker image based on rockylinux:8 with included

- [asterisk](https://github.com/asterisk/asterisk): asterisk PBX
- [asterisk-chan-dongle](https://github.com/shalzz/asterisk-chan-dongle): asterisk module for sending sms-es and doing calls using gsm dongle
- [freepbx]: managment interface for asterisk

I am using this image to setup SIP/gsm gateway, so I can use fixed phone numbers
from anywhere and without being location tracked by telco.

## Notes

### Getting IMEI and IMSI from GSM model


```
$ socat - /dev/ttyUSB2,crnl
> AT+GSN (get IMEI)
< 123456789012345
< OK
>AT+CIMI (get IMSI)
< 123456789012345
< OK
```