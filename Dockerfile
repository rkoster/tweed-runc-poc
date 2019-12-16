FROM alpine AS image
RUN apk add skopeo
RUN mkdir /image
RUN skopeo copy --format=oci docker://rkoster/mysql-tweed-stencil:latest oci:image:latest
RUN tar -C /image -cvf /image.tar .

FROM ubuntu:19.04
RUN apt-get update && apt-get install software-properties-common -y

RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install golang-go -y

COPY --from=image /image.tar /image.tar

ADD main.go go.mod go.sum /src/
ADD vendor /src/vendor
RUN cd /src && GOFLAGS=-mod=vendor go build -o /tweed

ENTRYPOINT /tweed
