#!/usr/bin/env bash

set -e

function msg()
{
    echo -e "\n$1"
}

if [[ 0 != $(id -u) ]]; then
    msg "Run this script as admin"
    exit 1
fi

if [[ ! -f /usr/bin/which ]]; then 
    msg "can't find binary which pleas install in order to proceed"
    exit 1
fi 

if [ -z $(which docker) ]; then
    msg "Install docker "
    curl -fsSL https://get.docker.com -o get-docker.sh
    if [ "3de5760e4236edea9dcd4fcc35a26c3bc555c0de30a5dd254477b501fab9fe35" != $(sha256dum get-docker.sh | awk 'print $1') ]; then
        msg "get-docker.sh hasn't the expected sha256sum abort"
        exit 1
    fi
    sh get-docker.sh && rm -f get-docker.sh
else 
    msg "Docker already installed, skip"
fi


if [ ! -z "${SUDO_USER}" ]; then
    msg "Add current user to docker group";
    usermod -aG docker "${SUDO_USER}"
    HOME="/home/${SUDO_USER}"
    if [ ! -f /etc/sudoers.d/wsl2-init-${SUDO_USER} ]; then
        msg "Add sudoers entry"
        echo "${SUDO_USER}    ALL=(ALL:ALL) NOPASSWD: /home/${SUDO_USER}/wsl2-tools/init-root.sh" > /etc/sudoers.d/wsl2-init-${SUDO_USER}
    fi
    chmod o-rwx /etc/sudoers.d/wsl2-init-${SUDO_USER}
fi

echo "${HOME}"

msg "Add init script to ~/.bashrc"
cp ${HOME}/.bashrc ${HOME}/.bashrc.old
echo "source ${HOME}/wsl2-tools/init.sh" >> ${HOME}/.bashrc 
