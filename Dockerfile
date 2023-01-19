FROM alpine:3.17.0

# install bash for scripting
RUN apk add --no-cache bash="5.2.15-r0"

# run commands with bash instead of sh; fail due to an error at any stage of piped commands
SHELL ["/bin/bash", "-eo", "pipefail", "-c"]

# add the setup scripts to the container
COPY ./libexec/ /usr/libexec/docker-pxe/

# add the user scripts to the path
ENV PATH="$PATH:/usr/libexec/docker-pxe"

# install and configure dnsmasq for DNS proxy and DHCP/TFTP server
RUN setup-dnsmasq

# syslinux is a suite of bootloaders, one of which is PXELINUX
RUN setup-syslinux

# iPXE build for Alpine Linux netboot
RUN setup-ipxe

# copy configuration files
COPY ./etc/ /etc/

# create a non-root user for the service
RUN adduser -D -g GECOS -s bash tftp

# create a directory for logs and other things that the tftp user can access
RUN mkdir -p /var/lib/dnsmasq/ && chown tftp:tftp /var/lib/dnsmasq/

# copy the files to serve over TFTP
COPY ./srv/ /srv/

# work out of the tftp user's home directory
WORKDIR /home/tftp

# default to running as the tftp user
USER tftp

# run dnsmasq in no-daemon mode when the container starts
ENTRYPOINT ["dnsmasq", "--no-daemon"]
