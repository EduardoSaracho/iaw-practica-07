#!/bin/bash
set -x

############################################################################################
# Variables de configuracion
############################################################################################

# Configuramos la IP privada de la máquina de MySQL
IP_MYSQL=172.31.22.213

############################################################################################
# Actualizamos el sistema
############################################################################################

apt update -y
apt upgrade -y

############################################################################################
# Instalación de la pila LEMP (Solución 1: Socket UNIX en la misma máquina)
############################################################################################

# Instalamos el servidor web Nginx
apt install nginx -y

# Instalamos el paquete de PHP FastCGI Process Manager
apt install php-fpm -y

# Instalamos el paquete para conectar con MySQL
apt install php-mysql -y

# Copiamos el archivo de configuración de Nginx
cp conf/default_socket_unix /etc/nginx/sites-available/default

# Reiniciamos el servidor web Nginx
systemctl restart nginx

###########################################################################################
# Despliegue de la aplicación web
###########################################################################################

cd /var/www/html

# Clonamos el repositorio de la aplicación
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Movemos el código fuente de la aplicación al directorio /var/www/html
mv iaw-practica-lamp/src/* .

# Eliminamos el archivo index.html
rm -f /var/www/html/index.html

# Eliminamos el directorio del repositorio
rm -rf /var/www/html/iaw-practica-lamp

# Configuramos la dirección IP de MySQL en el archivo de configuración
sed -i "s/localhost/$IP_MYSQL/" /var/www/html/config.php

# Cambiamos el propietario y el grupo de los archivos
chown www-data:www-data /var/www/html -R