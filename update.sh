#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

echo -e "\n${GREEN}Updating...${NOCOLOR}\n"

if [ $# -eq 1 ]; then
    bot=$1
else
    read -r -p "Choose a object: " bot
fi

echo -e "${GREEN}Updating the scripts...${NOCOLOR}\n"
cd ~/scp-079/scripts || exit
git pull
python3 -m venv venv
source venv/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -r requirements.txt
deactivate

if [ "$bot" = "scripts" ]; then
    echo -e "\n${GREEN}Scripts Updated!${NOCOLOR}\n"
    exit
fi

cd ~/scp-079/"$bot" || exit

git pull

source venv/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -r requirements.txt
deactivate

systemctl --user restart "$bot"

echo -e "\n${GREEN}Bot ${bot^^} Updated!${NOCOLOR}\n"
