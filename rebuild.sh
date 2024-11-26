#!/bin/bash
set -Eeuo pipefail

cat <<__EOF__ >>/etc/apt/sources.list.d/ubuntu.sources
Types: deb-src
URIs: http://archive.ubuntu.com/ubuntu/
Suites: noble noble-updates noble-backports
Components: main universe restricted multiverse
Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
__EOF__

apt-get -y update && \
apt-get -y upgrade && \
apt-get -y install git ruby wget rsync devscripts && \
apt-get -y build-dep mozc && \
apt-get -y source mozc

export DEBIAN_FRONTEND=noninteractive
UT_REPOSITORY="merge-ut-dictionaries"

if [ -e "${UT_REPOSITORY}" ]; then
    ( cd "${UT_REPOSITORY}" && git pull )
else
    git clone "https://github.com/utuhiro78/${UT_REPOSITORY}.git"
fi

pushd merge-ut-dictionaries/src/merge
    sed -i 's/python/python3/g' ./make.sh
    RUBYOPT="-Ku" bash ./make.sh
popd

pushd mozc*dfsg
    mv src/data/dictionary_oss/dictionary00.txt{,.orig}

    cat src/data/dictionary_oss/dictionary00.txt.orig \
        ../merge-ut-dictionaries/src/merge/mozcdic-ut.txt \
        > src/data/dictionary_oss/dictionary00.txt

    ls -al src/data/dictionary_oss/dictionary00.txt{,.orig}

    dch --local "+ut" "Add UT dictionaries."
    #dch --nmu "Add UT dictionaries."
    dpkg-buildpackage -b -uc -us -r >/dev/null
popd

mkdir -p packages
mv *.deb packages
ls -al packages/*.deb