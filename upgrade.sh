#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"

echo -e "\n${GREEN}Updating the scripts...${NOCOLOR}\n"
cd ~/scp-079/scripts || return || exit
git pull

if [ ! -d "venv" ]; then
    python3 -m venv venv
fi

source venv/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -r requirements.txt
deactivate
# shellcheck source=./env.sh
source ~/scp-079/scripts/env.sh

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n${GREEN}Updating the bot ${bot^^}...${NOCOLOR}\n"
        
        cd ~/scp-079/"$bot" || return || exit
        
        git pull
        
        source venv/bin/activate
        pip install -U pip
        pip install -U setuptools wheel
        pip install -r requirements.txt
        deactivate
        
        systemctl --user restart "$bot"
        
        echo -e "\n${GREEN}Bot ${bot^^} Updated!${NOCOLOR}\n"
    fi
done
shopt -u nullglob
