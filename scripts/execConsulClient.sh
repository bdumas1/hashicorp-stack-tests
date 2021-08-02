DEFAULT_SERVER_IP=172.16.0.2
DEFAULT_IP=172.16.0.2

IP="${1:-$DEFAULT_IP}"
SERVER_IP="${2:-DEFAULT_SERVER_IP}"

cat >/etc/consul.d/config.hcl <<EOF
data_dir = "/var/lib/consul"

client_addr    = "0.0.0.0"
advertise_addr = "${IP}"
retry_join     = [ "${SERVER_IP}" ]

ports {  
  grpc = 8502
}
EOF

cat >/etc/systemd/system/consul.service <<EOF
[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/consul agent \
  -config-dir=/etc/consul.d \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable consul.service
systemctl start consul
