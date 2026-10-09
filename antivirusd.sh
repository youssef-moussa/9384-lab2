#!/bin/bash

scan() {
    for file in "$dir"/*
    do
        malicious=0
        case "$file" in (*.exe|*.bat|*.vbs|*.scr|*.ps1)
            malicious=1;;
        esac
        if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"
        then
            malicious=1
        fi
        if [ "$malicious" -eq 1 ]
        then
            echo "$file is malicious and it is DELETED"
            cp "$file" "$malicious_dir"
            rm "$file"
        fi
    done
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
