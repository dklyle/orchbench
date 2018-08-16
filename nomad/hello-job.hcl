job "hello" {
  group "hellos" {
    count = 1
    type = "service"
    task "server" {
      driver = "docker"
      config {
	image = "dklyle/hello-node:v2"
      }
      resources {
        network {
          port "http" {
            static = 8080
          }
        }
      }
    }
  }
} 
