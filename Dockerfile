FROM alpine AS rootfs
RUN apk add skopeo
RUN mkdir /rootfs
RUN skopeo copy --format=oci docker://rkoster/mysql-tweed-stencil:latest dir:/rootfs

FROM ubuntu:19.04
RUN apt-get update && apt-get install software-properties-common -y

RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install golang-go -y

COPY --from=rootfs /rootfs /rootfs

RUN apt-get install libseccomp-dev -y

ADD system-preparation /bin/system-preparation
ADD main.go go.mod go.sum /src/
ADD vendor /src/vendor
RUN cd /src && GOFLAGS=-mod=vendor go build -tags seccomp -o /tweed

ENTRYPOINT /tweed
