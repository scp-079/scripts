#!/bin/bash

CONFIG_PATH="data/config/config.ini"

if [ $# -eq 1 ];then
    bot=$1
else
    read -r -p "Choose a bot: " bot
fi

cd ~/scp-079/"$bot" || exit

# TODO TEMP
if [ -f "examples/config.ini" ]; then
    CONFIG_PATH="data/config/config.ini"
else
    CONFIG_PATH="config.ini"
fi

vim "$CONFIG_PATH"
