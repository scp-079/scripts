#!/bin/bash

for bot in $(ls ~/scp-079); do
	if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
		echo -e "\n\033[0;32mStoping the bot ${bot^^}...\033[0m\n"
		systemctl --user stop $bot
		echo -e "\n\033[0;32mBot ${bot^^} Stopped!\033[0m\n"
	fi
done
