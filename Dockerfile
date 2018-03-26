FROM arm32v6/alpine:latest

MAINTAINER Mathieu Legrand <mathieu@legrand.im>

RUN apk update && \
    apk add openssh && \
    deluser $(getent passwd 33 | cut -d: -f1) && \
    delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    mkdir -p ~root/.ssh /etc/authorized_keys /etc/ssh/keys && chmod 0 ~root/.ssh/ && \
    mkdir -p /etc/authorized_keys && chmod 755 /etc/authorized_keys && \
    rm -rf /var/cache/apk/*

EXPOSE 22

COPY motd /etc/motd
COPY etc/ssh/* /etc/ssh/
COPY sshd_config /etc/ssh/sshd_config
COPY limited-key.pub /etc/authorized_keys/limited
COPY entry.sh /entry.sh

RUN addgroup -g 1000 -S limited && \
    adduser -u 1000 -S limited -G limited -s '' && \
    passwd -u limited && \
    chown root /home/limited && \
    touch /home/limited/.ash_history && chmod 444 /home/limited/.ash_history && \
    echo "exit" > /home/limited/.profile && \
    mkdir /home/limited/.ssh && chmod 550 /home/limited/.ssh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"] 
