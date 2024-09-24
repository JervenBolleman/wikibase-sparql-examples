#!/bin/bash 

echo "# Summary regarding test failues"

echo -e "$(tail -n 14 $1)"

start=-1

while read i
do
    if [[ $start -gt 0 ]]
    then
        echo "## $(sed -n "${start}p;${i}q" $1 | grep -oP '(test.+)'|cut -c 5-)"
        echo ""
        echo "| Failures | Success |"
        echo "| -------- | ------- |"
        echo "|$(sed -n "${start},${i}p;${i}q" $1 | grep -c -oP '\w+\/.+✘.+')|$(sed -n "${start},${i}p;${i}q" $1 | grep -c -oP '✔')|"
        echo ""
    fi
    start=$i
done < <(cat <(grep -n -P "^(\ +\│  \├\─+)|(\ +└─ )test" $1 | cut -f 1 -d ':') <(wc -l $1|cut -f 1 -d ' '))

echo "# Links to failing tests"

start=-1
while read i
do
    if [[ $start -gt 0 ]]
    then
        echo "## $(sed -n "${start}p;${i}q" $1 | grep -oP '(test.+)'|cut -c 5-)"
        echo ""
        echo "|File  | Error |"
        echo "| ---- | ----- |"
        while read j
        do
            file=$(echo "${j}" |cut -f 1 -d '✘')
            failure=$(echo "${j}" |cut -f 2 -d '✘')
            echo "| [$file](examples/$file.md) | $failure |"
        done < <(sed -n "${start},${i}p;${i}q" $1 | grep -oP '\w+\/.+✘.+')
        echo ""
    fi
    start=$i
done < <(cat <(grep -n -P "^(\ +\│  \├\─+)|(\ +└─ )test" $1 | cut -f 1 -d ':') <(wc -l $1|cut -f 1 -d ' '))
