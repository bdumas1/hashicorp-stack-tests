#!/bin/bash

DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

mkdir -p /etc/nomad.d

cat > /etc/nomad.d/config.hcl <<EOF
data_dir = "/var/lib/nomad"

server {
  enabled = true
  bootstrap_expect = 3

  server_join {  
    retry_join = [ "172.16.0.2", "172.16.0.3", "172.16.0.4" ]
  }
}

client {
  enabled = true
}
EOF

echo "[Unit]
Description=Nomad Service Discovery Agent
Documentation=https://www.nomad.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/bin/nomad agent \
  -config=/etc/nomad.d \
  -node=$IP \
  -bind=$IP \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==

ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/nomad.service

systemctl enable nomad.service
systemctl start nomad

# echo "export NOMAD_ADDR=http://$IP:4646" >> /home/core/.bashrc
