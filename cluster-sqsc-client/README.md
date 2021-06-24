# Cluster Sqsc Client

This Vagrant configuration deploys **3 virtual machines** called **nodes** containing:
- **Nomad** in client and server mode
- **Consul** in client and server mode

To run

```shell-session
$ vagrant up
```

To destroy

```shell-session
$ vagrant destroy -f
```

## UI

- **Nomad** :  [http://172.16.0.2:4646](http://172.16.0.2:4646)
- **Consul** : [http://172.16.0.2:8500](http://172.16.0.2:8500)

## Example

You can run a nomad job in any server of nodes. For example here, an `nginx` nomad job is run with the aim of deploying **3 instances** or **allocations** on the `ClientServer1` node (but it could also have been `ClientServer2` or `ClientServer2`, the most important thing is that it's deployed on a **Nomad server**).

```shell-session
$ vagrant ssh ClientServer1
$ cd /jobs
$ nomad run nginx.nomad
```

As such, **3 allocations** is deployed, spread on the 3 nodes (no sure yet if it's by default like that).

You can suspend 1 node to see what's going on:

```shell-session
$ vagrant suspend ClientServer1
```

and then resume it:

```shell-session
$ vagrant resume ClientServer1
```
