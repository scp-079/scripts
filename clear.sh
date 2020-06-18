#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

if [ $# -eq 1 ];then
    bot=$1
    cp /dev/null ~/scp-079/"$bot"/log
    echo -e "\n${GREEN}Bot ${bot^^}'s log file Cleared!${NOCOLOR}\n"
    exit
fi

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        cp /dev/null ~/scp-079/"$bot"/log
        echo -e "\n${GREEN}Bot ${bot^^}'s log file Cleared!${NOCOLOR}\n"
    fi
done
shopt -u nullglob
