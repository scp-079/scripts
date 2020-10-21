#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

LOG_PATH="log/log"

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n${GREEN}Showing the bot ${bot^^}'s log...${NOCOLOR}\n"
        cd ~/scp-079/"$bot" || exit

        # TODO TEMP
        if [ -f "examples/config.ini" ]; then
            LOG_PATH="log/log"
        else
            LOG_PATH="log"
        fi

        cat "$LOG_PATH"
        echo -e "\n${GREEN}Bot ${bot^^}'s log showed!${NOCOLOR}\n"
    fi
done
shopt -u nullglob
