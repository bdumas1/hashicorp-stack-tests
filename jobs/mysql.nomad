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

    network {
      port "mysql" {
        static = 3306
      }
      mode = "bridge"
    }

    task "mysql" {
      driver = "docker"

      env {
        MYSQL_ROOT_PASSWORD = "password"
      }

      config {
        image = "mysql"
        ports = ["mysql"]
      }

      resources {
        cpu = 500
        memory = 512
      }
    }

    service {
        name = "mysql"
        port = "mysql"

        connect {
          sidecar_service {}
        }

        // check {
        //   name = "mysql alive"
        //   type = "tcp"
        //   interval = "10s"
        //   timeout = "2s"
        // }
      }
  }
}