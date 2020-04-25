#!/bin/bash

if [ $# -eq 1 ];then
    time=$1
else
    read -p "Set the restart time: " time
fi

for bot in $(ls ~/scp-079); do
    if [ "$bot" != "scripts" ] && [ "$bot" != "venv" ] && ! [[ "$bot" =~ ^(conda)$ ]]; then
        systemctl --user enable $bot
    fi
done

mkdir -p ~/.config/systemd/user

echo "[Unit]
Description=Restart SCP-079 Service

[Service]
Type=oneshot
ExecStart=/bin/bash /home/`whoami`/scp-079/scripts/schedule.sh
" > ~/.config/systemd/user/restart.service

echo "[Unit]
Description=SCP-079 Reboot Scheduling

[Timer]
OnCalendar=*-*-* $time

[Install]
WantedBy=timers.target
" > ~/.config/systemd/user/restart.timer

systemctl --user daemon-reload
systemctl --user enable restart.timer
systemctl --user start restart.timer
