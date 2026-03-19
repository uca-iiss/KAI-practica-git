terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "nginx_rep" {
  count = 3
  image = docker_image.nginx.image_id
  name  = "TF_EJ1_${count.index}"
  ports {
    internal = 80
    external = var.nginx_host_port + count.index
  }
}
