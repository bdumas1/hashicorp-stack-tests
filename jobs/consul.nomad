job "consul" {
  datacenters = ["dc1"]
  group "consul" {
    count = 1
    task "consul" {
      driver = "raw_exec"
      config {
        command = "consul"
        args    = ["agent", "-dev"]
      }
      artifact {
        source = "https://releases.hashicorp.com/consul/1.9.6/consul_1.9.6_linux_amd64.zip"
      }
    }
  }
}