
FROM openjdk

ARG serverzip
EXPOSE 25565/tcp
EXPOSE 25565/udp

WORKDIR /srv

COPY ./SetupServer.sh /srv/
COPY mcserver /srv/mcserver

WORKDIR /srv/mcserver

ENTRYPOINT ServerStart.sh
