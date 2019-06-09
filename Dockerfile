
FROM openjdk:8-jre

ARG serverzip
EXPOSE 25565/tcp
EXPOSE 25565/udp
EXPOSE 8080/tcp

WORKDIR /srv

COPY main /srv/mcserver/
COPY mcserver /srv/mcserver

WORKDIR /srv/mcserver

ENTRYPOINT /srv/mcserver/main
