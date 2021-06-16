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

    task "wordpress" {
      driver = "docker"

      config {
        image = "wordpress"

        port_map {
          http = 80
        }
      }

      env {
        WORDPRESS_DB_HOST     = "172.16.0.2:3306"
        WORDPRESS_DB_NAME     = "wordpress"
        WORDPRESS_DB_USER     = "root"
        WORDPRESS_DB_PASSWORD = "password"
      }

      service {
        name = "wordpress"
        tags = ["global"]
        port = "http"

        check {
          name     = "wordpress running on port 80"
          type     = "http"
          protocol = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }

      resources {
        cpu = 500 # Mhz
        memory = 512 # MB

        network {
          mbits = 10

          port "http" {
            static = 80
          }
        }
      }
    }
  }
}