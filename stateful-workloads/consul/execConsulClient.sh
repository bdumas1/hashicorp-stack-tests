DEFAULT_SERVER_IP=172.17.0.2
DEFAULT_IP=172.17.0.3

IP="${1:-$DEFAULT_IP}"
SERVER_IP="${2:-DEFAULT_SERVER_IP}"

echo "[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/consul agent \
  -node=$IP \
  -bind=$IP \
  -client=0.0.0.0 \
  -advertise=$IP \
  -data-dir=/var/lib/consul \
  -retry-join=$SERVER_IP \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==

ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/consul.service

systemctl enable consul.service
systemctl start consul