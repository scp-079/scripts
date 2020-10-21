#!/bin/bash

LOG_PATH="data/log/log"

if [ $# -eq 1 ];then
    bot=$1
else
    read -r -p "Choose a bot: " bot
fi

cd ~/scp-079/"$bot" || exit

# TODO TEMP
if [ -f "examples/config.ini" ]; then
    LOG_PATH="data/log/log"
else
    LOG_PATH="log"
fi

less "$LOG_PATH"
