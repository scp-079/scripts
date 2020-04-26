#!/bin/bash

echo -e "\n\033[0;32mUpdating the bot...\033[0m\n"

if [ $# -eq 1 ]; then
    bot=$1
else
    read -p "Choose a bot: " bot
fi

cd ~/scp-079/$bot

git pull

source venv/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -r requirements.txt
deactivate

systemctl --user restart $bot

echo -e "\n\033[0;32mBot ${bot^^} Updated!\033[0m\n"
