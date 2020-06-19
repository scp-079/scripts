#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"
RED="\033[0;31m"

if [ $# -eq 1 ];then
    bot=$1

    if [ ! -f "config.ini" ]; then
        cp config.ini.example config.ini
    fi

    echo -e "\n${GREEN}Restoring the bot ${bot^^}'s backup...${NOCOLOR}"
    mkdir -p ~/scp-079
    cd ~/scp-079 || exit
    tar xf ~/scp-079-"$bot".tar.gz
    echo -e "${GREEN}Bot ${bot^^}'s backup restored!${NOCOLOR}\n"
    exit
fi

echo -e "\n${GREEN}Restoring all bots' backup...${NOCOLOR}"
cd ~ || exit
tar xf ~/scp-079.tar.gz
echo -e "${GREEN}All bots' backup restored!${NOCOLOR}\n"
