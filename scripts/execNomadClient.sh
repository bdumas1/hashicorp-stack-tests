#!/bin/bash

DEFAULT_SERVER_IP=172.16.0.2
DEFAULT_IP=172.17.0.2

IP="${1:-$DEFAULT_IP}"
SERVER_IP="${2:-DEFAULT_SERVER_IP}"

TAG="odd"
if [ $(($(echo ${IP} | awk -F. '{print x,$NF}')%2)) -eq 0 ]; then
	TAG="even"
fi

cat >/etc/nomad.d/nomad-client.hcl <<EOF
data_dir  = "/var/lib/nomad"

bind_addr = "0.0.0.0" # the default

advertise {
  http = "${IP}"
  rpc  = "${IP}"
  serf = "${IP}"
}

client {
  enabled    = true
  servers    = ["${SERVER_IP}"]
  node_class = "nclient"

  meta {
    type = "client"
    tag  = "${TAG}"
  }
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}
EOF

cat >/etc/systemd/system/nomad.service <<EOF
[Unit]
Description=Nomad Service Discovery Agent
Documentation=https://www.nomad.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent \
  -config=/etc/nomad.d \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nomad.service
systemctl start nomad

echo "export NOMAD_ADDR=http://$IP:4646" >> /home/vagrant/.bashrc
echo "NOMAD_ADDR=http://$IP:4646" >> /etc/environment
