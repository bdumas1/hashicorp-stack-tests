
## Nomad

### Installation

```shell-session
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -`
$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"`
$ sudo apt-get update && sudo apt-get install nomad`
```

### UI

[http://localhost:4646](http://localhost:4646)

## Traefik

```shell-session
$ nomad job run traefik.nomad
```

[http://localhost:8081](http://localhost:8081)

## Consul

```shell-session
$ nomad job run consul.nomad
```

[http://localhost:8500](http://localhost:8500)


## http-echo

```shell-session
$ nomad job run http-echo.nomad
```

[http://localhost/myapp](http://localhost/myapp)