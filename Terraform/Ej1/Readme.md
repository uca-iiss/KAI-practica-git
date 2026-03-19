Pasos para instalar la infraestructura del ejercicio 1:
- terraform init: con este comando se encarga de inicializar el proyecto. Es el responsable de descargar los proveedores, configurar el entorno y preparar la infraestructura.ç
  
- terraform fmt: el comando ayuda a dar estructura a todos los archivos .tf que se encuentren en la infraestructura para que estos se adapten al estándar. No realiza cambios mayores, solo mejoras de legibilidad, como identaciones o espacios.
  
- terraform validate: gracias a este comando podemos saber si existe algun error en nuestros archivos a nivel de sintaxis y utilización. Este tampoco crea ni modifica nada, solo se encarga de avisar de la existencia (si la hay) de dichos errores.

- terraform plan: genera un plan de mostrando los cambios que hara Terraform en la estructura. No realiza ningún cambio y solo sirve a título informativo para conocer los recursos creados, modificados y eliminados.

- terraform apply: aplica todos los cambios que han sido informados en el plan, adecuando la infraestructura real a lo mostrado en este. Solicita confirmación del usuario para concretarse.
