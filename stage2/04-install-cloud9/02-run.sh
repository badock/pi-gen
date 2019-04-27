#!/bin/bash -e

on_chroot << EOF
#dpkg-reconfigure -f noninteractive tzdata
#apt-get install -y git nodejs tmux
if [ ! -d c9sdk ]; then
   git clone https://github.com/c9/core.git c9sdk
fi
cd c9sdk
bash scripts/install-sdk.sh
EOF
