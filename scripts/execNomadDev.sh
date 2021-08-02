DEFAULT_IP=172.16.0.2
IP="${1:-$DEFAULT_IP}"

cat >/etc/systemd/system/nomad.service <<EOF
[Unit]
Description=Nomad Scheduler Agent (dev mode)
Documentation=https://www.nomad.io/
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/local/bin/nomad agent \
  -network-interface=eth1 \
  -dev
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl enable nomad.service
systemctl start nomad

echo "export NOMAD_ADDR=http://$IP:4646" >> /home/vagrant/.bashrc
echo "NOMAD_ADDR=http://$IP:4646" >> /etc/environment
