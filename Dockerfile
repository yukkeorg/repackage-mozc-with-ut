ARG UBUNTU_IMAGE_TAG

FROM ubuntu:${UBUNTU_IMAGE_TAG}

RUN sed -i 's/^# deb-src/deb-src/g' /etc/apt/sources.list
RUN apt-get -y update && \
    apt-get -y install git ruby apt-src wget rsync devscripts

# ENV HOME /home/repackage
# RUN useradd -m -s /bin/bash -d /home/repackage repackage
# USER rebuilder
WORKDIR /home/repackage
COPY repackage.sh .

ENTRYPOINT ["bash"]
