#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
else
    read -r -p "Choose a bot: " bot
fi

cd ~/scp-079/"$bot" || exit

less log
