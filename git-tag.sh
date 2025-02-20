#!/bin/bash

if [ x"$1" = x ]; then
    echo "Please enter tag name！"
    exit 1
fi
    if [ x"$2" = x ]; then
        git tag -a "$1" -m "$1"
        git push origin $1
    fi
        git tag -a "$1" -m "$2"
        git push origin $1


#git tag -a "$1" -m "$1"
#git push origin $1
