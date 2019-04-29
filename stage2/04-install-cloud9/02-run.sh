#!/bin/bash -e

on_chroot << EOF
#dpkg-reconfigure -f noninteractive tzdata
#apt-get install -y git nodejs tmux

dpkg-reconfigure locales # add the en_GB.UTF-8 locale and set as default
export LANGUAGE=en_GB.UTF-8 
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
locale-gen en_GB.UTF-8
update-locale en_GB.UTF-8

dpkg-reconfigure locales
nodejs /c9sdk/server.js -l 0.0.0.0 -a name:passwd -w /root
localedef -f UTF-8 -i en_US en_US.UTF-8

if [ ! -d c9sdk ]; then
   git clone https://github.com/c9/core.git c9sdk
fi
cd c9sdk
bash scripts/install-sdk.sh
EOF
