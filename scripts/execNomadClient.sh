#!/bin/bash

DEFAULT_SERVER_IP=172.16.0.2
DEFAULT_IP=172.17.0.2

IP="${1:-$DEFAULT_IP}"
SERVER_IP="${2:-DEFAULT_SERVER_IP}"

echo "[Unit]
Description=Nomad Service Discovery Agent
Documentation=https://www.nomad.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent \
  -node=$IP \
  -bind=$IP \
  -client \
  -network-interface=eth1 \
  -data-dir=/var/lib/nomad \
  -retry-join=$SERVER_IP \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==

ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nomad.service

systemctl enable nomad.service
systemctl start nomad
