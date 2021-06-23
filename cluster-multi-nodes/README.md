This Vagrant configuration deploys a cluster multi nodes with always **one server** and **one or many clients**.

The server contains :
- Docker
- Nomad Server
- Consul Server
- **Consul Connect** enabled in a configuration file (`scripts/conf/consul-server.conf`)

The clients contains :
- Docker
- Nomad Client
- Consul Client
- **gRPC** port opened for **Consul Connect** in a configuration file (`scripts/conf/consul-client.conf`)

# Run

`vagrant up`

# Destroy

`vagrant destroy -f`