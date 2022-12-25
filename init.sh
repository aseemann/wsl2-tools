#!/usr/bin/env bash

sudo ${HOME}/wsl2-tools/init-root.sh

env=~/.ssh/agent.env

agent_load_env () { 
    test -f "$env" && \
    source "$env" >| /dev/null ; 
}
agent_start () {
    (umask 077; ssh-agent >| "$env")
    source "$env" >| /dev/null ; 
}

agent_load_env
# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)
if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env

fi [ -f ${SSH_PRIVATE_KEY} ]; then
    ssh-add -l | grep ${SSH_PRIVATE_KEY} > /dev/null
    if [ $? == 1 ]; then
        ssh-add ${SSH_PRIVATE_KEY}
    fi
fi
