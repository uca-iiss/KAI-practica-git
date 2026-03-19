variable "wordpress_host" {
  description = "Valor de la variable de entorno del host de wordpress"
  type        = string
  default     = "base_datos"
}

variable "wordpress_name" {
  description = "Valor de la variable de entorno del nombre de wordpress"
  type        = string
  default     = "kai_wordpress"
}

variable "wordpress_user" {
  description = "Valor de la variable de entorno del usuario de wordpress"
  type        = string
  default     = "kevana"
}

variable "wordpress_password" {
  description = "Valor de la variable de entorno de la contraseña de wordpress"
  type        = string
  sensitive   = true
}

variable "wordpress_host_port" {
  description = "Puerto en el host para acceder a wordpress"
  type        = number
}

variable "Docker_red" {
  description = "Nombre de la red de conexion"
  type        = string
}
