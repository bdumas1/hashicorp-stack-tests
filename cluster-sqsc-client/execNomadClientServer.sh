#!/bin/bash

DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

TAG="odd"
if [ $(($(echo ${IP} | awk -F. '{print x,$NF}')%2)) -eq 0 ]; then
	TAG="even"
fi

mkdir -p /etc/nomad.d

cat > /etc/nomad.d/config.hcl <<EOF
data_dir = "/var/lib/nomad"

bind_addr = "0.0.0.0" # the default

advertise {
  http = "${IP}"
  rpc  = "${IP}"
  serf = "${IP}"
}

server {
  enabled = true
  bootstrap_expect = 3

  server_join {  
    retry_join = [ "172.16.0.2", "172.16.0.3", "172.16.0.4" ]
  }
}

client {
  enabled    = true
  node_class = "nnodes"

  meta {
    type = "client-server"
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
Description=Nomad Scheduler Agent
Documentation=https://www.nomad.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/opt/bin/nomad agent \
  -config=/etc/nomad.d \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nomad.service
systemctl start nomad

# Because of the way /etc/provile script is written,
# putting extra environment variables into /etc/profile.env
# prevents former PATH to also contain /opt/bin, therefore,
# it needs to be re-inserted there :-(
cat >>/etc/profile.env <<EOF
export NOMAD_ADDR=http://${IP}:4646
export ROOTPATH='/opt/bin'
EOF
