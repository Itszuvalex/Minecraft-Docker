
FROM openjdk

ARG serverzip
EXPOSE 25565/tcp
EXPOSE 25565/udp

WORKDIR /srv

COPY main /srv/mcserver/
COPY mcserver /srv/mcserver

WORKDIR /srv/mcserver

ENTRYPOINT /srv/mcserver/main
