#!/bin/bash

DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

echo "[Unit]
Description=Nomad Service Discovery Agent
Documentation=https://www.nomad.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent \
  -node=$IP \
  -bind=$IP \
  -server \
  -bootstrap-expect=1 \
  -data-dir=/var/lib/nomad \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==

ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nomad.service

systemctl enable nomad.service
systemctl start nomad

echo "export NOMAD_ADDR=http://$IP:4646" >> /home/vagrant/.bashrc
