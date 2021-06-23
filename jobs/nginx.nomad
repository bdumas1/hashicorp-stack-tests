job "nginx" {
  datacenters = ["dc1"]

  group "nginx" {
    count = 1

    restart {
      interval = "5m"
      attempts = 10
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "http" {
        to = 80
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"
        ports = ["http"]
      }

      resources {
        memory = 256 # MB
      }
    }

    service {
      name = "nginx"
      tags = ["global"]
      port = "http"
    }
  }
}
