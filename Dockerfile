ARG IMAGE="ubuntu"

FROM ${IMAGE}
WORKDIR /home/repackage
COPY rebuild.sh .
