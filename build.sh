#!/bin/bash

read -p "Project: " project
read -p "Name: " name

mkdir -p ~/scp-079
git clone https://github.com/scp-079/scp-079-$project.git ~/scp-079/$name
cd ~/scp-079/$name

if [ "$project" != "noporn" ]; then
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
Description=SCP-079-${project^^} Telegram Bot {$name^^} Service
After=default.target

[Service]
WorkingDirectory=/home/`whoami`/scp-079/$name
ExecStart=/home/`whoami`/scp-079/$name/venv/bin/python main.py
Restart=on-abort

[Install]
WantedBy=default.target
" > ~/.config/systemd/user/$name.service

systemctl --user daemon-reload
systemctl --user enable $name
