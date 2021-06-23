job "wordpress" {
  datacenters = ["dc1"]

  group "wordpress" {
    count = 1

    restart {
      interval = "5m"
      attempts = 10
      delay    = "25s"
      mode     = "delay"
    }

    network {
      port "http" {
        static = 80
      }
      mode = "bridge"
    }

    task "wordpress" {
      driver = "docker"

      config {
        image = "wordpress"
        ports = ["http"]
      }

      env {
        WORDPRESS_DB_HOST     = "${NOMAD_UPSTREAM_ADDR_mysql}"
        WORDPRESS_DB_NAME     = "wordpress"
        WORDPRESS_DB_USER     = "root"
        WORDPRESS_DB_PASSWORD = "password"
      }

      resources {
        cpu = 500 # Mhz
        memory = 512 # MB
      }
    }

    service {
      name = "wordpress"
      tags = ["global"]
      port = "http"

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name  = "mysql"
              local_bind_port   = 3306
            }
          }
        }
      }

      check {
        name     = "wordpress running on port 80"
        type     = "http"
        protocol = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
  }
}
