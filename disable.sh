#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
    echo -e "\n\033[0;32mDisabling the bot ${bot^^}...\033[0m\n"
    systemctl --user stop "$bot"
    systemctl --user disable "$bot"
    echo -e "\n\033[0;32mBot ${bot^^} Disabled!\033[0m\n"
    exit
fi

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n\033[0;32mDisabling the bot ${bot^^}...\033[0m\n"
        systemctl --user stop "$bot"
        systemctl --user disable "$bot"
        echo -e "\n\033[0;32mBot ${bot^^} Disabled!\033[0m\n"
    fi
done
shopt -u nullglob

systemctl --user stop restart.timer
systemctl --user disable restart.timer
