#!/bin/bash

if [ "$(id -u)" -eq 0 ]; then
	echo "Please DO NOT run the script as root user!"
	return
fi

mkdir -p ~/scp-079
cd ~/scp-079 || exit

update_scripts() {
    echo -e "\n\033[0;32mUpdating the scripts...\033[0m\n"

    if [ ! -d "scripts" ]; then
        git clone https://github.com/scp-079/scripts.git scripts
        cd scripts || exit
    else
        cd scripts || exit
        git pull
    fi

    python3 -m venv venv
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
    echo -e "\n\033[0;32mCloning the project ${project^^}...\033[0m\n"
    
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
}

bot_config() {
    if [ ! -f "config.ini" ]; then
        cp config.ini.example config.ini
    fi

    cd ~/scp-079/scripts || exit

    if [ ! -f ~/scp-079/scripts/config.ini ]; then
        cp ~/scp-079/"$name"/config.ini config.ini
    fi

    source venv/bin/activate
    python config.py "$name"
    deactivate

    bash ~/scp-079/scripts/config.sh "$name"

    echo -e "\n\033[0;32mConfig updated!\033[0m\n"

    if [ -f "template.txt" ] && [ ! -f "report.txt" ]; then
        cp template.txt report.txt
    fi

    if [ -f "report.txt" ]; then
        vim report.txt
        echo -e "\033[0;32mReport template updated!\033[0m\n"
    fi  
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

    echo -e "\033[0;32mEnabling the systemd service...\033[0m\n"

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
    echo -e "\n\033[0;32mCompleted!\033[0m\n"  
}

build_begin
build_end
