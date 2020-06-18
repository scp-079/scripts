#!/bin/bash

shopt -s nullglob
for bot in ~/scp-079/*; do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n\033[0;32mUpdating the bot ${bot^^}...\033[0m\n"
        
        cd ~/scp-079/"$bot" || exit
        
        git pull
        
        source venv/bin/activate
        pip install -U pip
        pip install -U setuptools wheel
        pip install -r requirements.txt
        deactivate
        
        systemctl --user restart "$bot"
        
        echo -e "\n\033[0;32mBot ${bot^^} Updated!\033[0m\n"
    fi
done
shopt -u nullglob
