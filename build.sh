#!/bin/bash

read -p "Project: " project
read -p "Name: " name

mkdir -p ~/scp-079
cd ~/scp-079

echo -e "\n\033[0;32mCloning the project ${project^^}...\033[0m\n"

if [ ! -d "$name" ]; then
    git clone https://github.com/scp-079/scp-079-$project.git $name
    cd $name
else
    cd $name
    git pull
fi

if [ ! -d "venv" ] && [ "$project" != "noporn" ]; then
    echo -e "\n\033[0;32mCreating the virtual environment without system site packages...\033[0m"
    python3 -m venv venv
elif [ ! -d "venv" ]; then
    echo -e "\n\033[0;32mCreating the virtual environment with system site packages...\033[0m"
    python3 -m venv --system-site-packages venv
fi

echo -e "\n\033[0;32mInstalling the requirements...\033[0m\n"

source venv/bin/activate
pip install -U pip
pip install -U setuptools wheel
pip install -r requirements.txt
deactivate

if [ ! -f "config.ini" ]; then
    cp config.ini.example config.ini
fi

vim config.ini

echo -e "\n\033[0;32mConfig updated!\033[0m\n"
echo -e "\033[0;32mEnabling the systemd service...\033[0m\n"

mkdir -p ~/.config/systemd/user

echo "[Unit]
Description=SCP-079-${project^^} Telegram Bot ${name^^} Service
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

echo "------------------------"
echo -e "\n\033[0;32mCompleted!\033[0m\n"
