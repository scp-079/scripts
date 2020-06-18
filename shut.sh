#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

shopt -s nullglob
for bot in ~/scp-079/*; do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n${GREEN}Stopping the bot ${bot^^}...${NOCOLOR}\n"
        systemctl --user stop "$bot"
        echo -e "\n${GREEN}Bot ${bot^^} Stopped!${NOCOLOR}\n"
    fi
done
shopt -u nullglob
