#!/bin/bash

scan() {
    echo "scanning"
}


if [ $# -ne 3 ]
then
    echo "Usage: $0 dir malicious_dir interval-secs"
    exit 1
fi

dir="$1"
malicious_dir="$2"
interval="$3"

if [ ! -d "$malicious_dir" ]
then  
    mkdir "$malicious_dir"
fi

if [ ! -f directory-info.last ]
then
    scan
    ls -l "$dir" > directory-info.last
fi

while true
do
    sleep "$interval"
    ls -l "$dir" > directory-info.new
    if ! cmp -s directory-info.last directory-info.new
    then
        scan
        cp directory-info.new directory-info.last
    fi
done
