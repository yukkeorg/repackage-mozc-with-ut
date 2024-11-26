ARG IMAGE="ubuntu:noble"

FROM ${IMAGE}
WORKDIR /home/repackage
COPY rebuild.sh .