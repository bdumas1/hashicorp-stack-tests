DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

echo "[Unit]
Description=Consul Service Discovery Agent
Documentation=https://www.consul.io/
After=network-online.target
Wants=network-online.target

[Service]
Restart=on-failure
ExecStart=/usr/local/bin/consul agent \
  -config-file=/home/vagrant/consul-server.hcl \
  -node=$IP \
  -bind=$IP \
  -client=0.0.0.0 \
  -ui \
  -server \
  -bootstrap-expect=1 \
  -advertise=$IP \
  -encrypt=TeLbPpWX41zMM3vfLwHHfQ==

ExecReload=/bin/kill -HUP $MAINPID

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/consul.service

systemctl enable consul.service
systemctl start consul
