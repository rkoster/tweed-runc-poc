FROM ubuntu:19.04

RUN apt-get update && apt-get install software-properties-common -y

RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install golang-go -y

ADD main.go go.mod go.sum /src/
RUN cd /src && go build -o /tweed

ADD rootfs /rootfs

ENTRYPOINT /tweed
