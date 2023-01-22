#!/bin/sh

set -eu

git clone https://github.com/utuhiro78/merge-ut-dictionaries.git

(
    cd merge-ut-dictionaries/src

    git clone https://github.com/utuhiro78/mozcdic-ut-alt-cannadic.git
    git clone https://github.com/utuhiro78/mozcdic-ut-edict2.git
    git clone https://github.com/utuhiro78/mozcdic-ut-jawiki.git
    git clone https://github.com/utuhiro78/mozcdic-ut-neologd.git
    git clone https://github.com/utuhiro78/mozcdic-ut-personal-names.git
    git clone https://github.com/utuhiro78/mozcdic-ut-place-names.git
    git clone https://github.com/utuhiro78/mozcdic-ut-skk-jisyo.git
    git clone https://github.com/utuhiro78/mozcdic-ut-sudachidict.git

    cp mozcdic-ut-*/mozcdic-ut-*.txt.tar.bz2 .
    for f in mozcdic-ut-*.txt.tar.bz2; do
        tar xf "$f"
    done

    export RUBYOPT="-Ku"
    bash ./make.sh

    ls mozcdic-ut.txt
)

apt-src install ibus-mozc
(
    cd mozc-*+dfsg
    DEBEMAIL="nomail@nomail.local" dch -l "+ut" "Add UT dictionary."

    cd src/data/dictionary_oss/
    cp dictionary00.txt dictionary00.txt.orig
    cat dictionary00.txt.orig ../../../../merge-ut-dictionaries/src/mozcdic-ut.txt > dictionary00.txt

    ls -al dictionary00.txt*
)
apt-src build ibus-mozc
ls -al *.deb

mkdir -p packages
mv *.deb packages
tar cf pkgs.tar packages
