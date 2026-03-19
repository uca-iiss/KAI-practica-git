Pasos para la instalación de la infraestructura del ejercicio 2:
-
En este segundo ejercicio enfocaremos la resolución con los siguientes ficheros, que incluiremos dentro de una carpeta con nombre por ejemplo, **mi-proyecto-terraform**:

- providers.tf
- wordpress.tf
- mariadb.tf
- variables.tf
- terraform.tfvars
- outputs.tf
- network.tf

En estos ficheros incluiremos la siguiente información:

Comando : nano providers.tf
```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.6.2"
    }
  }
}

provider "docker" {}
```
Comando : nano wordpress.tf
```
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
```
Comando : nano mariadb.tf
```
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
```
Comando : nano variables.tf
```
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
```
Comando : nano terraform.tfvars
```
Docker_red          = "red_bdweb"
wordpress_host_port = 8080
wordpress_password  = "clavekevana"
wordpress_host      = "mariadb"       # Para que coincida con el alias en mariadb.tf
wordpress_name      = "kai_wordpress" # El nombre de la base de datos
wordpress_user      = "kevana"        # El usuario
```
Comando : nano outputs.tf
```
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
```
Comando : nano network.tf
```
resource "docker_network" "my_network" {
  name = var.Docker_red
}
```
El fichero network.tf es necesario dado que queremos una misma red para ambos contenedores si ponemos la red en WordPress.tf y mariadb.tf nos saldrá error de duplicación de red.

Una vez configurado todo lo necesario para la creación de la infraestructura, pasamos a realizar los siguientes comandos:
```
terraform init
```
Este comando descarga los "plugins" (providers) necesarios (en nuestro caso, Docker) y prepara el directorio de trabajo.
```
terraform fmt
```
Este comando nos sirve para formatear el código automáticamente. Nos permite ajustar los espacios, alineaciones, entre otros aspectos de nuestros archivos .tf para que sigan el estándar oficial de HashiCorp. No cambia la lógica, solo pone el código "bonito" y legible.
```
terraform validate
```
Este comando nos permite verificar que la sintaxis sea correcta y comprobamos que no tengamos errores de escritura, que las variables estén declaradas y que los recursos tengan los argumentos permitidos.
Si no obtenemos errores el resultado es: Success! The configuration is valid.
En el caso de obtener errores los corregimos y volvemos a ejecutar terraform validate.
```
terraform plan
```
Este comando nos muestra qué va a pasar antes de que ocurra la contrucción de la infraestructura. Nos indica los recursos a añadir, destruir o modificar. Además, comparamos nuestro código con el estado real de nuestro Docker. Es fundamental para no romper nada por accidente.
En nuestro caso obtendremos a añadir 7 recursos siendo estos: dos imágenes, dos contenedores, dos volúmenes y la red.
```
terraform apply
```
Este comando ejecuta los cambios que hemos podido visualizar en plan. Por lo que hace que la realidad coincida con nuestro código. Llama a la API de Docker y crea/modifica los contenedores, redes y volúmenes de verdad. Al final, genera o actualiza el archivo terraform.tfstate.

Finalmente, una vez creado esta infraestructura podemos comprobar su creación en "http://localhost:8080", todos los cambios y datos se almacenarán en los volúmenes de cada contenedor por lo que si eliminamos los contenedores al mover a lanzar la infraestructura los cambios se mantienen.
