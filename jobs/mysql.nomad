job "mysql" {
  datacenters = ["dc1"]

  group "mysql" {
    count = 1

    restart {
      interval = "5m"
      attempts = 10
      delay = "25s"
      mode = "delay"
    }

    task "mysql" {
      driver = "docker"

      env {
        MYSQL_ROOT_PASSWORD = "password"
      }

      config {
        image = "mysql"
        
        port_map {
          http = 3306
        }
      }

      service {
        name = "mysql"
        port = "mysql"

        check {
          name = "mysql alive"
          type = "tcp"
          interval = "10s"
          timeout = "2s"
        }
      }

      resources {
        cpu = 500
        memory = 1024

        network {
          mbits = 10

          port "mysql" {
            static = 3306
          }
        }
      }
    }
  }
}