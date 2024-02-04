FROM alpine:3.19
LABEL maintainer="Gus Esquivel <gesquive@gmail.com>"

RUN apk add --no-cache ca-certificates tzdata && update-ca-certificates

RUN apk add --no-cache openssh rsync openssh-sftp-server && \
    truncate -s 0 /etc/motd

COPY configs/sshd.conf /etc/ssh/sshd_config.d/secure.conf
COPY configs/profile.conf /etc/profile.d/secure.sh
COPY configs/init.sh /usr/bin/init

WORKDIR /config
VOLUME /config
VOLUME /share
EXPOSE 22

ENTRYPOINT ["/usr/bin/init"]
CMD ["/usr/sbin/sshd", "-D", "-e"]
