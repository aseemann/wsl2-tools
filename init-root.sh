#!/usr/bin/env bash

if [ ! -d /run/screen ]; then
    echo -e "Create screen session directory"
    mkdir -p -m 0777 /run/screen
fi

if [ ! -S /var/run/docker.sock ]; then
    echo -e "Start docker"
    mkdir -p /sys/fs/cgroup/systemd || :
    mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd || :
    /etc/init.d/docker start
fi

if [ ! -f /var/run/crond.pid ]; then
    echo -e "Start cron daemon"
    cron
fi
