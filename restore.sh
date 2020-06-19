#!/bin/bash

NOCOLOR="\033[0m"
GREEN="\033[0;32m"
RED="\033[0;31m"

update_scripts() {
    echo -e "\n${GREEN}Updating the scripts...${NOCOLOR}\n"

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

# Restore specific bot

if [ $# -eq 1 ];then
    bot=$1

    if [ ! -f ~/scp-079-"$bot".tar.gz ]; then
        echo -e "\n${RED}File ~/scp-079-$bot.tar.gz does not exist!${NOCOLOR}\n"
        return || exit
    fi

    echo -e "\n${GREEN}Restoring the bot ${bot^^}'s backup...${NOCOLOR}"
    mkdir -p ~/scp-079
    cd ~/scp-079 || return || exit
    tar xf ~/scp-079-"$bot".tar.gz
    update_scripts

    echo "$bot $bot" | bash ~/scp-079/scripts/rebuild.sh
    set_env
    echo -e "${GREEN}Bot ${bot^^}'s backup restored!${NOCOLOR}\n"

    return || exit
fi

# Restore all bots

if [ ! -f ~/scp-079.tar.gz ]; then
    echo -e "\n${RED}File ~/scp-079.tar.gz does not exist!${NOCOLOR}\n"
    return || exit
fi

echo -e "\n${GREEN}Restoring all bots' backup...${NOCOLOR}"
cd ~ || return || exit
tar xf ~/scp-079.tar.gz
update_scripts

shopt -s nullglob
for bot in ~/scp-079/*; do
    bot=$(basename "$bot")
    if [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        echo "$bot $bot" | bash ~/scp-079/scripts/rebuild.sh
    fi
done
shopt -u nullglob

set_env
echo -e "${GREEN}All bots' backup restored!${NOCOLOR}\n"
