#!/bin/bash
set -Eeu -o pipefail

#RUN sed -i 's/^# deb-src/deb-src/g' /etc/apt/sources.list

cat <<_EOF_ >>/etc/apt/sources.list.d/ubuntu.sources

Types: deb-src
URIs: http://archive.ubuntu.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
_EOF_

apt-get -y update && \
apt-get -y upgrade && \
apt-get -y install git ruby wget rsync devscripts && \
apt-get -y build-dep mozc

clone_or_pull_utuhiro78repo() {
    if [ -e "$1" ]; then
        ( cd "$1" && git pull )
    else
        git clone "https://github.com/utuhiro78/${1}.git"
    fi
}

clone_or_pull_utuhiro78repo "merge-ut-dictionaries"

cd merge-ut-dictionaries/src
sed -i 's/python/python3/g' ./make.sh
RUBYOPT="-Ku" bash ./make.sh
