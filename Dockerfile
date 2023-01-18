FROM alpine:3.17.0

RUN apk add --no-cache bash

COPY ./etc/ /etc/
COPY ./libexec/ /usr/libexec/docker-pxe/

WORKDIR /usr/libexec/docker-pxe
RUN ./setup-dnsmasq \
 && ./setup-memtest \
 && ./setup-syslinux \
 && ./create-tftp-user \
 && ./tftp-files

WORKDIR /home/tftp
USER tftp

ENTRYPOINT ["dnsmasq", "--no-daemon"]
CMD ["--dhcp-range=192.168.56.2,proxy"]
