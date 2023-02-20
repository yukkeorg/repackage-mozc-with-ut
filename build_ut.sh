#!/bin/bash

set -eux

clone_or_pull_utuhiro78repo() {
    if [ -e "$1" ]; then
        ( cd "$1" && git pull )
    else
        git clone "https://github.com/utuhiro78/${1}.git"
    fi
}

clone_or_pull_utuhiro78repo "merge-ut-dictionaries"

cd merge-ut-dictionaries/src
RUBYOPT="-Ku" bash ./make.sh
