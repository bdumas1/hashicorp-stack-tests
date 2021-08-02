#!/bin/bash

echo "########## Updating system..."
sudo apt-get update
sudo apt-get upgrade -y
echo "########## Installing Docker..."
sudo apt-get remove docker docker-engine docker.io
echo '* libraries/restart-without-asking boolean true' | sudo debconf-set-selections
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
sudo apt-get update
sudo apt-get install -y docker-ce
# Restart docker to make sure we get the latest version of the daemon if there is an upgrade
sudo service docker restart
# Make sure we can actually use docker as the vagrant user
sudo usermod -aG docker vagrant
sudo docker --version

# Packages required for nomad & consul
sudo apt-get install unzip vim -y

echo "########## Installing Nomad..."
NOMAD_VERSION=1.1.3
cd /tmp/
curl -sSL https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip -o nomad.zip
sudo unzip -q nomad.zip -d /usr/local/bin/
sudo mkdir -p /etc/nomad.d
sudo chmod a+w /etc/nomad.d


echo "########## Installing Consul..."
CONSUL_VERSION=1.10.1
curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip -o consul.zip
sudo unzip -q consul.zip -d /usr/local/bin/
sudo mkdir -p /var/lib/consul /etc/consul.d
sudo chmod -R 775 /var/lib/consul

# https://discuss.hashicorp.com/t/failed-to-find-plugin-bridge-in-path/3095
CNI_PLUGINS_VERSION=0.9.1
echo "########## Enable CNI Plugin"
curl -sSL https://github.com/containernetworking/plugins/releases/download/v${CNI_PLUGINS_VERSION}/cni-plugins-linux-amd64-v${CNI_PLUGINS_VERSION}.tgz -o cni-plugins.tgz
sudo mkdir -p /opt/cni/bin
sudo tar -C /opt/cni/bin -xzf cni-plugins.tgz
