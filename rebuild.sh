#!/bin/bash

project_config() {
    echo ""
    read -r -p "Project: " project
    read -r -p "Name: " name
}

set_env() {
    # shellcheck source=./env.sh
    source ~/scp-079/scripts/env.sh
}

create_venv() {
    if [ ! -d "venv" ] && [ "$project" != "noporn" ]; then
        echo -e "\n${GREEN}Creating the virtual environment without system site packages...${NOCOLOR}"
        python3 -m venv venv
    elif [ ! -d "venv" ]; then
        echo -e "\n${GREEN}Creating the virtual environment with system site packages...${NOCOLOR}"
        python3 -m venv --system-site-packages venv
    fi

    echo -e "\n${GREEN}Installing the requirements...${NOCOLOR}\n"

    source venv/bin/activate
    pip install -U pip
    pip install -U setuptools wheel
    pip install -r requirements.txt
    deactivate
}

enable_service() {
    mkdir -p ~/.config/systemd/user

    echo "[Unit]
Description=SCP-079-${project^^} Telegram Bot ${name^^} Service
After=default.target

[Service]
WorkingDirectory=/home/$(whoami)/scp-079/$name
ExecStart=/home/$(whoami)/scp-079/$name/venv/bin/python main.py
Restart=on-abort

[Install]
WantedBy=default.target" > ~/.config/systemd/user/"$name".service

    echo -e "${GREEN}Enabling the systemd service...${NOCOLOR}\n"

    systemctl --user daemon-reload
    systemctl --user enable "$name"
}

build_begin() {
    project_config
    set_env
    cd ~/scp-079/"$name" || exit
    create_venv
    enable_service
}

build_end() {
    cd ~ || exit
    echo "------------------------"
    echo -e "\n${GREEN}Completed!${NOCOLOR}\n"
}

build_begin
build_end
