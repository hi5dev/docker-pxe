FROM alpine:3.17.0

RUN apk add --no-cache bash="5.2.15-r0"

COPY ./libexec/ /usr/libexec/docker-pxe/
WORKDIR /usr/libexec/docker-pxe
RUN ./setup-dnsmasq && ./setup-memtest && ./setup-syslinux

COPY ./etc/ /etc/
RUN ./create-tftp-user
WORKDIR /home/tftp
USER tftp

ENTRYPOINT ["dnsmasq", "--no-daemon"]
CMD ["--dhcp-range=192.168.56.2,proxy"]
