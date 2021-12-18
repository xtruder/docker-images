FROM ubuntu:21.10

# install qemu-kvm, libvirt daemon and required dependencies
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils && \
    apt-get autoclean && \
    apt-get autoremove

# copy configurations
COPY libvirtd.conf /etc/libvirt/libvirtd.conf
COPY qemu.conf /etc/libvirt/qemu.conf

# copy startup script
COPY startup.sh /

# create volumes
VOLUME /run/libvirt
VOLUME /etc/libvirt/qemu
VOLUME /var/lib/libvirt

ENTRYPOINT [ "/startup.sh" ]
