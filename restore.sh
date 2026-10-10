#!/bin/bash

if [ $# -ne 2 ]
then
    echo "Usage: $0 dir malicious_dir"
    exit 1
fi

dir="$1"
malicious_dir="$2"

while true
do
    if [ -z "$(ls "$malicious_dir")" ]
    then
        echo "No malicious files to review."
        exit 0
    fi

    files=("$malicious_dir"/*)
    for i in "${!files[@]}"
    do
        echo "$((i+1))) ${files[$i]}"
    done

    read -p "Pick a file number: " choice
    case "$choice" in ''|*[!0-9]*)
        echo "Please enter a number"
        continue
        ;;
    esac
    if [ "$choice" -lt 1 ] || [ "$choice" -gt "${#files[@]}" ]
    then
        echo "You picked a wrong file"
        continue
    fi

    picked="${files[choice-1]}"
    read -p "1) Restore  2) Delete permanently  3) Back: " action
    case "$action" in
        1)  mv "$picked" "$dir"
            echo "Restored $(basename "$picked") to $dir."
            ;;
        2)  rm "$picked"
            echo "$(basename "$picked") permanently deleted."
            ;;
        3)  :
            ;;
        *)  echo "Invalid Option."
            ;;
    esac
done
