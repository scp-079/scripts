#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

if [ $# -eq 1 ];then
    bot=$1
    echo -e "\n${GREEN}Disabling the bot ${bot^^}...${NOCOLOR}\n"
    systemctl --user stop "$bot"
    systemctl --user disable "$bot"
    echo -e "\n${GREEN}Bot ${bot^^} Disabled!${NOCOLOR}\n"
    exit
fi

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n${GREEN}Disabling the bot ${bot^^}...${NOCOLOR}\n"
        systemctl --user stop "$bot"
        systemctl --user disable "$bot"
        echo -e "\n${GREEN}Bot ${bot^^} Disabled!${NOCOLOR}\n"
    fi
done
shopt -u nullglob

systemctl --user stop restart.timer
systemctl --user disable restart.timer
