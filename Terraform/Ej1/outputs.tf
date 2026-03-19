output "nginx_url_1" {
  description = "URL para acceder al contenedor 1 de Nginx"
  value       = "http://localhost:${var.nginx_host_port + 0}"
}

output "nginx_url_2" {
  description = "URL para acceder al contenedor 2 de Nginx"
  value       = "http://localhost:${var.nginx_host_port + 1}"
}

output "nginx_url_3" {
  description = "URL para acceder al contenedor 3 de Nginx"
  value       = "http://localhost:${var.nginx_host_port + 2}"
}
