FROM ubuntu:noble

RUN apt-get update && apt-get install -y nano gnupg2 bash curl bind9-utils dnsutils net-tools traceroute iputils-ping openssh-server tinycdb
RUN echo 'root:S3mentar4' | chpasswd
RUN ssh-keygen -A
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
COPY pdns.list.txt /etc/apt/sources.list.d/pdns.list
COPY dnsdist-19.txt /etc/apt/preferences.d/pdns 
RUN install -d /etc/apt/keyrings; curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/dnsdist-19-pub.asc
RUN apt update && apt install -y dnsdist
COPY dnsdist.conf.txt /etc/dnsdist/dnsdist.conf

EXPOSE 53/udp 53/tcp 22/tcp 

CMD ["/bin/bash", "-c", "/usr/sbin/sshd -q && echo -e 'nameserver 127.0.0.1\nnameserver 103.80.80.231\nnameserver 8.8.8.8\nnameserver 1.1.1.1' > /etc/resolv.conf && /usr/bin/dnsdist -u _dnsdist -g _dnsdist --supervised --disable-syslog"]
