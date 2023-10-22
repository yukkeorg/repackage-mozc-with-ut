ARG IMAGE

FROM ${IMAGE}

RUN sed -i 's/^# deb-src/deb-src/g' /etc/apt/sources.list
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install git ruby wget rsync devscripts && \
    apt-get -y build-dep mozc

WORKDIR /home/repackage

COPY build_ut.sh .
COPY repackage.sh .