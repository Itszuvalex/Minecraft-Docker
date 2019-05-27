
FROM openjdk

ARG serverzip
EXPOSE 25565/tcp
EXPOSE 25565/udp

WORKDIR /srv

COPY main /srv/
COPY mcserver /srv/mcserver

WORKDIR /srv/mcserver

ENTRYPOINT /srv/main
