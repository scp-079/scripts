#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
else
    read -r -p "Choose a bot: " bot
fi

# shellcheck source=./venv/bin/activate
source ~/scp-079/"$bot"/venv/bin/activate
