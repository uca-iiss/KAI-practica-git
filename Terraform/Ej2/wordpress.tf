locals {
  puerto    = var.wordpress_host_port
  hostw     = var.wordpress_host
  nombrew   = var.wordpress_name
  usuariow  = var.wordpress_user
  passwordw = var.wordpress_password
}

resource "docker_image" "wordpress" {
  name         = "wordpress:latest"
  keep_locally = false
}

resource "docker_container" "wordpress_container" {
  image = docker_image.wordpress.image_id
  name  = "webwordpress"
  ports {
    internal = 80
    external = local.puerto
  }
  networks_advanced {
    name    = docker_network.my_network.name
    aliases = ["wordpress"]
  }
  depends_on = [docker_container.mariadb_container]
  restart    = "unless-stopped"
  volumes {
    volume_name    = docker_volume.my_volume_web.name
    container_path = "/var/www/html"
  }
  env = [
    "WORDPRESS_DB_HOST=${local.hostw}",
    "WORDPRESS_DB_NAME=${local.nombrew}",
    "WORDPRESS_DB_USER=${local.usuariow}",
    "WORDPRESS_DB_PASSWORD=${local.passwordw}"
  ]
}

resource "docker_volume" "my_volume_web" {
  name = "volume_wordpress"
}
