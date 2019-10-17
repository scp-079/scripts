#!/bin/bash

for bot in $(ls ~/scp-079); do
	if [ "$bot" != "conda" ] && [ "$bot" != "scripts" ] && [ "$bot" != "venv" ]; then
		systemctl --user enable $bot
	fi
done

systemctl --user enable restart.timer
systemctl --user start restart.timer
