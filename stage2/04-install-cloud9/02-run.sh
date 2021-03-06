#!/bin/bash -e

on_chroot << EOF
dpkg-reconfigure locales # add the en_GB.UTF-8 locale and set as default
export LANGUAGE=en_GB.UTF-8 
export LANG=en_GB.UTF-8
export LC_ALL=en_GB.UTF-8
locale-gen en_GB.UTF-8
update-locale en_GB.UTF-8

dpkg-reconfigure locales
localedef -f UTF-8 -i en_US en_US.UTF-8

if [ ! -d /var/lib/c9sdk ]; then
   git clone https://github.com/c9/core.git /var/lib/c9sdk
fi
cd /var/lib/c9sdk
bash scripts/install-sdk.sh

#nodejs /var/lib/c9sdk/server.js -l 0.0.0.0 -a name:passwd -w /root

mkdir /workspace

cat << EOF1 > /etc/systemd/system/c9.service
[Unit]
Description=Cloud9 IDE
Requires=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/c9
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF1

cat << EOF2 > /usr/local/bin/c9
#!/bin/sh
USERNAME="pi"
PASSWORD="raspberry"

nodejs /var/lib/c9sdk/server.js -l 0.0.0.0 \
    --listen 0.0.0.0 \
    --port 8181 \
    -a \$USERNAME:\$PASSWORD \
    -w /workspace
EOF2

chmod +x /usr/local/bin/c9

systemctl daemon-reload
systemctl start c9
systemctl enable c9

# Install packages for enabling python debugger in Cloud9
apt install -y python-dev python-pip
pip install ikpdb

EOF
