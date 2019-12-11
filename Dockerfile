FROM ubuntu:19.04

# RUN apt-get update && apt-get install -y \
#     btrfs-tools \
#     git \
#     golang-go \
#     go-md2man \
#     iptables \
#     libassuan-dev \
#     libbtrfs-dev \
#     libc6-dev \
#     libdevmapper-dev \
#     libglib2.0-dev \
#     libgpgme-dev \
#     libgpg-error-dev \
#     libprotobuf-dev \
#     libprotobuf-c0-dev \
#     libseccomp-dev \
#     libselinux1-dev \
#     libsystemd-dev \
#     pkg-config \
#     runc \
#     uidmap

RUN apt-get update \
    && apt-get install -qq -y software-properties-common uidmap slirp4netns \
    && add-apt-repository -y ppa:projectatomic/ppa \
    && apt-get update -qq \
    && apt-get -qq -y install podman

RUN mkdir -p /etc/containers \
    && echo "[registries.search]" >> /etc/containers/registries.conf \
    && echo "registries = ['docker.io', 'quay.io']" >> /etc/containers/registries.conf

RUN sed -i 's/overlay/vfs/g' /etc/containers/storage.conf

RUN echo 'cgroup_manager = "cgroupfs"' >> /etc/containers/libpod.conf
RUN echo 'events_logger = "file"' >> /etc/containers/libpod.conf

RUN podman info --debug

# RUN podman run --rm -it \
#     --network host \
#     --name no-net-alpine \
#     alpine:latest \
#     echo "hello from podman"
