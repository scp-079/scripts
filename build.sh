#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"
RED="\033[0;31m"

CONFIG_EXAMPLE_PATH="examples/config.ini"
CONFIG_PATH="data/config/config.ini"
JOIN_EXAMPLE_PATH="examples/join.txt"
JOIN_PATH="data/config/join.txt"
REPORT_EXAMPLE_PATH="examples/report.txt"
REPORT_PATH="data/config/report.txt"
START_EXAMPLE_PATH="examples/start.txt"
START_PATH="data/config/start.txt"

# TODO TEMP
if [ -f "examples/config.ini" ]; then
    CONFIG_EXAMPLE_PATH="examples/config.ini"
    CONFIG_PATH="data/config/config.ini"
else
    CONFIG_EXAMPLE_PATH="config.ini.example"
    CONFIG_PATH="config.ini"
fi

# TODO TEMP
if [ -f "examples/join.txt" ]; then
    JOIN_EXAMPLE_PATH="examples/join.txt"
    JOIN_PATH="data/config/join.txt"
else
    JOIN_EXAMPLE_PATH="join.txt.example"
    JOIN_PATH="join.txt"
fi

# TODO TEMP
if [ -f "examples/report.txt" ]; then
    REPORT_EXAMPLE_PATH="examples/report.txt"
    REPORT_PATH="data/config/report.txt"
else
    REPORT_EXAMPLE_PATH="report.txt.example"
    REPORT_PATH="report.txt"
fi

# TODO TEMP
if [ -f "examples/start.txt" ]; then
    START_EXAMPLE_PATH="examples/start.txt"
    START_PATH="data/config/start.txt"
else
    START_EXAMPLE_PATH="start.txt.example"
    START_PATH="start.txt"
fi

if [ "$(id -u)" -eq 0 ]; then
    echo -e "\n${RED}Please DO NOT run the script as root user!${NOCOLOR}\n"
    return || exit
fi

mkdir -p ~/scp-079
cd ~/scp-079 || exit

update_scripts() {
    echo -e "\n${GREEN}Updating the scripts...${NOCOLOR}\n"

    if [ ! -d "scripts" ]; then
        git clone https://github.com/scp-079/scripts.git scripts
        cd scripts || exit
    else
        cd scripts || exit
        git pull
    fi

    if [ ! -d "venv" ] || [ ! -f "venv/bin/activate" ]; then
        python3 -m venv venv
    fi

    source venv/bin/activate
    pip install -U pip
    pip install -U setuptools wheel
    pip install -r requirements.txt
    deactivate

    cd ../
}

set_env() {
    # shellcheck source=./env.sh
    source ~/scp-079/scripts/env.sh
}

project_config() {
    echo ""
    read -r -p "Project: " project
    read -r -p "Name: " name
}

git_clone() {
    echo -e "\n${GREEN}Cloning the project ${project^^}...${NOCOLOR}\n"
    
    if [ ! -d "$name" ]; then
        git clone https://github.com/scp-079/scp-079-"$project".git "$name"
        cd "$name" || exit
    else
        cd "$name" || exit
        git pull
    fi
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

    if [ "$project" == "tip" ]; then
        pip install -U pybind11
    fi

    pip install -r requirements.txt
    deactivate
}

bot_config() {
    mkdir -p data/config

    if [ ! -f "$CONFIG_PATH" ]; then
        cp "$CONFIG_EXAMPLE_PATH" "$CONFIG_PATH"
    fi

    if [ ! -f ~/scp-079/scripts/config.ini ]; then
        cp "$CONFIG_PATH" ~/scp-079/scripts/config.ini
    fi

    cd ~/scp-079/scripts || exit
    source venv/bin/activate
    python config.py "$name"
    deactivate

    cd ~/scp-079/"$name" || exit
    bash ~/scp-079/scripts/config.sh "$name"
    echo -e "\n${GREEN}Config updated!${NOCOLOR}\n"

    if [ -f "$JOIN_EXAMPLE_PATH" ] && [ ! -f "$JOIN_PATH" ]; then
        cp "$JOIN_EXAMPLE_PATH" "$JOIN_PATH"
    fi

    if [ -f "$JOIN_PATH" ]; then
        vim "$JOIN_PATH"
        echo -e "${GREEN}Join template updated!${NOCOLOR}\n"
    fi

    if [ -f "$REPORT_EXAMPLE_PATH" ] && [ ! -f "$REPORT_PATH" ]; then
        cp "$REPORT_EXAMPLE_PATH" "$REPORT_PATH"
    fi

    if [ -f "$REPORT_PATH" ]; then
        vim "$REPORT_PATH"
        echo -e "${GREEN}Report template updated!${NOCOLOR}\n"
    fi
    
    if [ -f "$START_EXAMPLE_PATH" ] && [ ! -f "$START_PATH" ]; then
        cp "$START_EXAMPLE_PATH" "$START_PATH"
    fi

    if [ -f "$START_PATH" ]; then
        vim "$START_PATH"
        echo -e "${GREEN}Start template updated!${NOCOLOR}\n"
    fi
}

enable_service() {
    mkdir -p ~/.config/systemd/user

    echo "[Unit]
Description=SCP-079-${project^^} Telegram Bot ${name^^} Service
After=default.target

[Service]
WorkingDirectory=/home/$(whoami)/scp-079/$name
ExecStart=/home/$(whoami)/scp-079/$name/venv/bin/python -u main.py
Restart=always
RestartSec=15

[Install]
WantedBy=default.target" > ~/.config/systemd/user/"$name".service

    echo -e "${GREEN}Enabling the systemd service...${NOCOLOR}\n"

    systemctl --user daemon-reload
    systemctl --user enable "$name"
}

build_begin() {
    update_scripts
    set_env
    project_config
    git_clone
    create_venv
    bot_config
    enable_service
}

build_end() {
    cd ~ || exit
    echo "------------------------"
    echo -e "\n${GREEN}Completed!${NOCOLOR}\n"
}

build_begin
build_end
