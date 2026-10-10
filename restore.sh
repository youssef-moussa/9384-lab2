#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

dir="$1"
malicious_dir="$2"

if [ -z "$(ls "$malicious_dir")" ]
then
    echo "No malicious files to review"
    exit 0
fi

files=("$malicious_dir"/*)
for i in "${!files[@]}"
do
    echo "$((i+1))) ${files[$i]}"
done

read -p "Pick a file number: " choice
picked="${files[choice-1]}"
echo "You picked: $picked"
