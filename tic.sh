#!/bin/bash
filename=$1
folder=$(date '+%Y%m%d-%Hh%M')
echo Start
mkdir $folder
while read website; do
    htmlpage=${website//\//__}
    wget -t 1 -T 30 -O $folder/$htmlpage $website
done < $filename
