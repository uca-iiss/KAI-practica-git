output "wordpress_url" {
  value = "http://localhost:${var.wordpress_host_port}"
}
output "network_name" {
  value = docker_network.my_network.name
}
output "mariadb_container" {
  description = "Nombre del contenedor mariadb"
  value       = docker_container.mariadb_container.name
}
