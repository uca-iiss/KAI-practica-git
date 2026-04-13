resource "docker_image" "mariadb" {
  name         = "mariadb:latest"
  keep_locally = false
}

resource "docker_container" "mariadb_container" {
  image = docker_image.mariadb.image_id
  name  = "webbasedatos"
  networks_advanced {
    name    = docker_network.my_network.name
    aliases = ["mariadb"]
  }
  volumes {
    volume_name    = docker_volume.my_volume_bd.name
    container_path = "/var/lib/mysql"
  }
  healthcheck {
    test     = ["CMD", "mariadb-admin", "ping", "-h", "localhost", "-u", "root", "-p${var.wordpress_password}"]
    interval = "10s"
    timeout  = "5s"
    retries  = 5
    start_period = "20s" # Tiempo de cortesía mientras se crea la BD por primera vez
  }
  lifecycle {
    prevent_destroy = true
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${var.wordpress_password}",
    "MYSQL_DATABASE=${var.wordpress_name}",
    "MYSQL_USER=${var.wordpress_user}",
    "MYSQL_PASSWORD=${var.wordpress_password}"
  ]
}

resource "docker_volume" "my_volume_bd" {
  name = "volume_mariadb"
}
