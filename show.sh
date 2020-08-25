#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

# TODO 适应新的 data 文件夹结构
shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n${GREEN}Showing the bot ${bot^^}'s log...${NOCOLOR}\n"
        cat ~/scp-079/"$bot"/log
        echo -e "\n${GREEN}Bot ${bot^^}'s log showed!${NOCOLOR}\n"
    fi
done
shopt -u nullglob
