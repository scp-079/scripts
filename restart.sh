#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
else
    read -r -p "Choose a bot: " bot
fi

systemctl --user kill -s SIGKILL "$bot"
