#!/bin/bash

libvirtd_pid=0
virtlogd_pid=0

# exit handler terminates and waits for libvirtd and logvirtd to exit
exit_handler() {
  if [ $libvirtd_pid -ne 0 ]; then
    kill -TERM "$libvirtd_pid"
    wait "$libvirtd_pid"
  fi

  if [ $virtlogd_pid -ne 0 ]; then
    kill -TERM "$virtlogd_pid"
    wait "$virtlogd_pid"
  fi
}

# set signal handlers for TERM and INT
trap 'exit_handler; exit 143' TERM
trap 'exit_handler; exit 130' INT

# try to create /dev/kvm if it does not exist
if [ ! -c /dev/kvm ]; then
  echo creating /dev/kvm
  mknod -m 0660 /dev/kvm c 10 232
fi

# make /dev/kvm writable by kvm user
chmod 0660 /dev/kvm
chown root:kvm /dev/kvm

# try to create tun device if it does not exist
if [ ! -c /dev/net/tun ]; then
  echo creating /dev/net/tun
  mkdir -p /dev/net
  mknod -m 0600 /dev/net/tun c 10 200
fi

# cannot write to /proc/sys/net/ipv6/conf/virbr1/disable_ipv6 to enable/disable IPv6 on bridge virbr1: Read-only file system
mount -o remount,rw /proc/sys

/usr/sbin/virtlogd &
libvirtd_pid="$!"

/usr/sbin/libvirtd -l "$@" &
virtlogd_pid="$!"

wait