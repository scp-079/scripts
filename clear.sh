#!/bin/bash

for bot in $(ls ~/scp-079); do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        cp /dev/null ~/scp-079/$bot/log
        echo -e "\n\033[0;32mBot ${bot^^}'s log file Cleared!\033[0m\n"
    fi
done
