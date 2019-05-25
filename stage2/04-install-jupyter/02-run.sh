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

# Install packages for enabling python debugger
apt install -y python3 python3-pip
#pip install ikpdb

python3 -m pip install --upgrade pip
python3 -m pip install jupyter

mkdir /workspace

cat << EOF1 > /etc/systemd/system/jupyter.service
[Unit]
Description=Jupyter Notebook
Requires=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/run-jupyter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF1

cat << EOF2 > /usr/local/bin/run-jupyter
#!/bin/sh
USERNAME="pi"
PASSWORD="raspberry"


jupyter-notebook --port 8181 --notebook-dir=/workspace --allow-root --ip="0.0.0.0" --NotebookApp.token="\$USERNAME" --NotebookApp.password="\$PASSWORD"

# nodejs /var/lib/c9sdk/server.js -l 0.0.0.0 \
#     --listen 0.0.0.0 \
#     --port 8181 \
#     -a \$USERNAME:\$PASSWORD \
#     -w /workspace
EOF2

chmod +x /usr/local/bin/run-jupyter

systemctl daemon-reload
systemctl start jupyter
systemctl enable jupyter

EOF
