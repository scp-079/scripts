#!/bin/bash

shopt -s nullglob
for bot in ~/scp-079/*; do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n\033[0;32mStopping the bot ${bot^^}...\033[0m\n"
        systemctl --user stop "$bot"
        echo -e "\n\033[0;32mBot ${bot^^} Stopped!\033[0m\n"
    fi
done
shopt -u nullglob
