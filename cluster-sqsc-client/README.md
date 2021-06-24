# Cluster Sqsc Client

This Vagrant configuration deploys **3 nodes** containing:
- **Nomad** in client and server mode
- **Consul** in client and server mode

## Example

You can run a nomad job in any server of nodes.

```shell-session
$ vagrant ssh <ClientServer1|ClientServer2|ClientServer3>
$ cd /jobs
$ nomad run nginx.nomad
```