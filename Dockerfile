FROM alpine AS image
RUN apk add skopeo
RUN mkdir /image
RUN skopeo copy --format=oci docker://rkoster/mysql-tweed-stencil:latest oci:image:latest

FROM ubuntu:19.04
RUN apt-get update && apt-get install software-properties-common -y

RUN add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get install golang-go -y

COPY --from=image /image /image

RUN apt-get install libseccomp-dev -y
RUN apt-get install go-md2man git -y

RUN go get -d github.com/opencontainers/image-tools/cmd/oci-image-tool \
    && cd /root/go/src/github.com/opencontainers/image-tools/ \
    && make all && make install
RUN mkdir /rootfs && oci-image-tool unpack --ref name=latest /image /rootfs

ADD main.go go.mod go.sum /src/
ADD vendor /src/vendor
RUN cd /src && GOFLAGS=-mod=vendor go build -tags seccomp -o /tweed

ENTRYPOINT /tweed
