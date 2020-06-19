#!/bin/bash

export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"

alias base="deactivate"
alias build="bash ~/scp-079/scripts/build.sh"
alias venv="source ~/scp-079/scripts/venv.sh"

alias config="bash ~/scp-079/scripts/config.sh"
alias log="bash ~/scp-079/scripts/log.sh"
alias restart="bash ~/scp-079/scripts/restart.sh"
alias status="bash ~/scp-079/scripts/status.sh"
alias start="bash ~/scp-079/scripts/start.sh"
alias stop="bash ~/scp-079/scripts/stop.sh"
alias try="bash ~/scp-079/scripts/try.sh"
alias update="bash ~/scp-079/scripts/update.sh"

alias check="bash ~/scp-079/scripts/check.sh"
alias clear="bash ~/scp-079/scripts/clear.sh"
alias disable="bash ~/scp-079/scripts/disable.sh"
alias enable="bash ~/scp-079/scripts/enable.sh"
alias global="bash ~/scp-079/scripts/global.sh"
alias refresh="bash ~/scp-079/scripts/refresh.sh"
alias show="bash ~/scp-079/scripts/show.sh"
alias shut="bash ~/scp-079/scripts/shut.sh"
alias upgrade="bash ~/scp-079/scripts/upgrade.sh"

alias backup="bash ~/scp-079/scripts/backup.sh"
alias restore="bash ~/scp-079/scripts/restore.sh"

touch ~/.bashrc

if ! grep -q "source ~/scp-079/scripts/env.sh" ~/.bashrc; then
    echo "source ~/scp-079/scripts/env.sh" >> ~/.bashrc
fi
