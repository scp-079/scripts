#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

LOG_PATH="data/log/log"

if [ $# -eq 1 ];then
    bot=$1
    cd ~/scp-079/"$bot" || exit

    # TODO TEMP
    if [ -f "examples/config.ini" ]; then
        LOG_PATH="data/log/log"
    else
        LOG_PATH="log"
    fi

    cp /dev/null "$LOG_PATH"
    rm -f log/log-*
    echo -e "\n${GREEN}Bot ${bot^^}'s log files Cleared!${NOCOLOR}\n"
    exit
fi

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        cd ~/scp-079/"$bot" || exit

        # TODO TEMP
        if [ -f "examples/config.ini" ]; then
            LOG_PATH="data/log/log"
        else
            LOG_PATH="log"
        fi

        cp /dev/null "$LOG_PATH"
        rm -f log/log-*
        echo -e "\n${GREEN}Bot ${bot^^}'s log files Cleared!${NOCOLOR}\n"
    fi
done
shopt -u nullglob
