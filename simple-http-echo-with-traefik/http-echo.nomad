job "http-echo" {
  datacenters = ["dc1"]

  group "echo" {
    count = 3

    // update {
    //   canary        = 1
    //   max_parallel  = 3
    // }

    task "server" {
      driver = "docker"
      
      config {
        image = "hashicorp/http-echo:latest"
        args = [
          "-listen", ":${NOMAD_PORT_http}",
          "-text", "update Hello and welcome to 127.0.0.1 running on port ${NOMAD_PORT_http}",
        ]
      }

      resources {
        network {
          mbits = 10
          port "http" {}
        }
      }

      service {
        name = "http-echo"
        port = "http"
        tags = [
          "traefik.enable=true",
          "traefik.http.routers.http.rule=Path(`/myapp`)",
        ]
        check {
          type      = "http"
          path      = "/health"
          interval  = "2s"
          timeout   = "2s"
        }
      }
    }
  }
}