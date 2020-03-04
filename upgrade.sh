#!/bin/bash

for bot in $(ls ~/scp-079); do
	if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
		echo -e "\n\033[0;32mUpdating the bot ${bot^^}...\033[0m\n"
		cd ~/scp-079/$bot
		git pull
		systemctl --user restart $bot
		echo -e "\n\033[0;32mBot ${bot^^} Updated!\033[0m\n"
	fi
done
