#!/bin/sh

set -eu

clone_or_pull_utuhiro78repo() {
    if [ -e "$1" ]; then
        ( cd "$1" && git pull )
    else
        git clone "https://github.com/utuhiro78/${1}.git"
    fi
}

clone_or_pull_utuhiro78repo "merge-ut-dictionaries"

(
    cd merge-ut-dictionaries/src
    RUBYOPT="-Ku" bash ./make.sh

    # for d in alt-cannadic edict2 jawiki neologd personal-names place-names skk-jisyo sudachidict; do
    #     clone_or_pull_utuhiro78repo "mozcdic-ut-$d"
    # done
    # cp mozcdic-ut-*/mozcdic-ut-*.txt.tar.bz2 .
    # for f in mozcdic-ut-*.txt.tar.bz2; do
    #     tar xf "$f"
    # done

    # cat mozcdic-ut-*.txt > mozcdic-ut.txt
 
    # export RUBYOPT="-Ku"
    # ruby remove_duplicate_ut_entries.rb mozcdic-ut.txt
    # ruby count_word_hits.rb
    # ruby apply_word_hits.rb mozcdic-ut.txt
)

apt-get source -y mozc-server
apt-get build-dep -y mozc-server
(
    cd mozc-*+dfsg

    mv src/data/dictionary_oss/dictionary00.txt{,.orig}
    cat src/data/dictionary_oss/dictionary00.txt.orig \
        ../merge-ut-dictionaries/src/mozcdic-ut.txt \
        > src/data/dictionary_oss/dictionary00.txt

    dpkg-source --commit

    DEBEMAIL="nomail@nomail.local" dch -l "+ut" "Add UT dictionary."
    dpkg-buildpackage -uc -us -ui
)

mkdir -p packages
mv *.deb packages
ls -al package/*.deb