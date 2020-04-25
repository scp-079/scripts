#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
else
    read -p "Choose a bot: " bot
fi

cd ~/scp-079/$bot

vim config.ini
