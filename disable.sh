#!/bin/bash

for bot in $(ls ~/scp-079); do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo -e "\n\033[0;32mDisabling the bot ${bot^^}...\033[0m\n"
        systemctl --user stop $bot
        systemctl --user disable $bot
        echo -e "\n\033[0;32mBot ${bot^^} Disabled!\033[0m\n"
    fi
done

systemctl --user stop restart.timer
systemctl --user disable restart.timer
