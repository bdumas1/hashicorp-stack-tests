DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

mkdir -p /etc/consul.d

cat > /etc/consul.d/config.hcl <<EOF
data_dir = "/var/lib/consul"

server = true
retry_join = [ "172.16.0.2", "172.16.0.3", "172.16.0.4" ]
bootstrap_expect = 3
EOF

echo "[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Restart=on-failure
ExecStart=/opt/bin/consul agent \
  -config-dir=/etc/consul.d \
  -node=$IP \
  -bind=$IP \
  -client=0.0.0.0 \
  -ui \
  -advertise=$IP \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==

ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/consul.service

systemctl enable consul.service
systemctl start consul
