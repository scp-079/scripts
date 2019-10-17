#!/bin/bash

echo -e "\n\033[0;32mUpdating the bot...\033[0m\n"

if [ $# -eq 1 ]; then
	bot=$1
else
	read -p "Choose a bot: " bot
fi

cd ~/scp-079/$bot

git pull

if [ "$bot" = "recheck" ]; then
	eval "$(conda shell.bash hook)"
	conda activate recheck
	pip install -r requirements.txt
	conda deactivate
else
	source ~/scp-079/venv/bin/activate
	pip install -r requirements.txt
	deactivate
fi

systemctl --user restart $bot

echo -e "\n\033[0;32mBot ${bot^^} Updated!\033[0m\n"
