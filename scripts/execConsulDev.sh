DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

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
  -dev
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
[Install]
WantedBy=multi-user.target" > /etc/systemd/system/consul.service

systemctl enable consul.service
systemctl start consul