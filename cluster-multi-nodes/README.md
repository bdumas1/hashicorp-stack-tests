# Cluster multi nodes

This Vagrant configuration deploys a cluster multi nodes with **one server** and **one or many clients**.

The server contains :
- Docker
- Nomad Server
- Consul Server
- Consul Connect

The clients contains :
- Docker
- Nomad Client
- Consul Client
- **gRPC** port opened for Consul Connect

# Run

`vagrant up`

# Destroy

`vagrant destroy -f`