#!/bin/bash 

echo "# Summary regarding test failues"

tail -n 14 $1 

start=-1

while read i
do
    if [[ $start -gt 0 ]]
    then
        echo "# $(sed -n "${start}p;${i}q" $1 | cut -c 35-)"
        echo ""
        echo "Failures  $(sed -n "${start},${i}p;${i}q" $1 | grep -c -oP '\w+\/.+✘.+')"
        echo ""
    fi
    start=$i
done < <(cat <(grep -n -P "   \│  \├\─[[:cntrl:]]+" $1 | cut -f 1 -d ':') <(wc -l $1|cut -f 1 -d ' '))

echo "# Links to failing tests"

start=-1
while read i
do
    if [[ $start -gt 0 ]]
    then
        echo "# $(sed -n "${start}p;${i}q" $1 | cut -c 35-)"
        echo ""
        echo "|File  | Error |"
        echo "| ---- | ----- |"
        while read j
        do
            file=$(echo "${j:3}" |cut -f 1 -d '✘')
            failure=$(echo "${j:3}" |cut -f 2 -d '✘')
            echo "| [$file](examples/$file.md) | $failure |"
        done < <(sed -n "${start},${i}p;${i}q" $1 | grep -oP '\w+\/.+✘.+')
        echo ""
    fi
    start=$i
done < <(cat <(grep -n -P "   \│  \├\─[[:cntrl:]]+" $1 | cut -f 1 -d ':') <(wc -l $1|cut -f 1 -d ' '))
