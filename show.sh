#!/bin/bash

for bot in $(ls ~/scp-079); do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n\033[0;32mShowing the bot ${bot^^}'s log...\033[0m\n"
        cat ~/scp-079/$bot/log
        echo -e "\n\033[0;32mBot ${bot^^}'s log showed!\033[0m\n"
    fi
done
