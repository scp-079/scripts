#!/bin/bash

if [ $# -eq 1 ];then
    bot=$1
else
    read -p "Choose a bot: " bot
fi

mkdir -p ~/scp-079
git clone https://github.com/scp-079/scp-079-$bot.git ~/scp-079/$bot
cd ~/scp-079/$bot

if [ "$bot" != "noporn" ]; then
    python3 -m venv venv
else
    python3 -m venv --system-site-packages venv
fi

source venv/bin/activate
pip install -r requirements.txt
deactivate

if ! test -f "config.ini"; then
    cp config.ini.example config.ini
fi

vim config.ini

mkdir -p ~/.config/systemd/user

echo "[Unit]
Description=SCP-079-${bot^^} Telegram Bot Service
After=default.target

[Service]
WorkingDirectory=/home/`whoami`/scp-079/$bot
ExecStart=/home/`whoami`/scp-079/$bot/venv/bin/python main.py
Restart=on-abort

[Install]
WantedBy=default.target
" > ~/.config/systemd/user/$bot.service

systemctl --user daemon-reload
systemctl --user enable $bot
