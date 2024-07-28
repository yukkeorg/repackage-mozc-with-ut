#!/bin/bash
set -Eeu -o pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get source -y mozc 

pushd mozc-*+dfsg
    mv src/data/dictionary_oss/dictionary00.txt{,.orig}

    cat src/data/dictionary_oss/dictionary00.txt.orig \
        ../merge-ut-dictionaries/src/mozcdic-ut.txt \
        > src/data/dictionary_oss/dictionary00.txt

    ls -al src/data/dictionary_oss/dictionary00.txt{,.orig}

    dch -l "+ut1" "Add UT dictionaries."
    #dch --nmu "Add UT dictionaries."
    dpkg-buildpackage -b -uc -us -r >/dev/null
popd

mkdir -p packages
mv *.deb packages
ls -al packages/*.deb
