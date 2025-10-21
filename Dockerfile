FROM ubuntu:noble

RUN apt-get update && apt-get install -y nano gnupg2 bash curl bind9-utils dnsutils net-tools traceroute iputils-ping
COPY pdns.list.txt /etc/apt/sources.list.d/pdns.list
COPY dnsdist-19.txt /etc/apt/preferences.d/pdns 
RUN install -d /etc/apt/keyrings; curl https://repo.powerdns.com/FD380FBB-pub.asc | tee /etc/apt/keyrings/dnsdist-19-pub.asc
RUN apt update && apt install -y dnsdist
COPY dnsdist.conf.txt /etc/dnsdist/dnsdist.conf

EXPOSE 53/udp 53/tcp 

CMD ["/usr/bin/dnsdist", "-u","_dnsdist", "-g", "_dnsdist" ,"--supervised" ,"--disable-syslog"]

