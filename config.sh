#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
else
    read -r -p "Choose a bot: " bot
fi

# TODO 适应新的 data 文件夹结构
cd ~/scp-079/"$bot" || exit

vim config.ini
