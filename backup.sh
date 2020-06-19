#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

if [ $# -eq 1 ];then
    bot=$1
    echo -e "\n${GREEN}Starting to backup the bot ${bot^^}...${NOCOLOR}"
    mkdir -p ~/scp-079/"$bot"
    cd ~/scp-079 || exit
    tar --exclude="venv" -czf ~/scp-079-"$bot".tar.gz "$bot"
    echo -e "${GREEN}Bot ${bot^^} backup finished!${NOCOLOR}\n"
    exit
fi

echo -e "\n${GREEN}Starting to backup all bots...${NOCOLOR}"
mkdir -p ~/scp-079
cd ~ || exit
tar --exclude="venv" ~/scp-079.tar.gz scp-079
echo -e "${GREEN}All bots backup finished!${NOCOLOR}\n"
