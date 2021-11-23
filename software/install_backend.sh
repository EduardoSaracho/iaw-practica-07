#!/bin/bash
set -x

############################################################################################
# Variables de configuracion
############################################################################################

MYSQL_ROOT_PASSWORD=root

############################################################################################
# Actualizamos el sistema
############################################################################################

apt update -y
apt upgrade -y

############################################################################################
# Instalación de la pila LAMP
############################################################################################

# Instalamos MySQL Server
apt install mysql-server -y

# Cambiamos la contraseña del usuario root
mysql <<< "ALTER USER root@'localhost' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_ROOT_PASSWORD';"

# Configuramos MySQL para aceptar conexiones desde cualquier interfaz de red
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de MySQL
systemctl restart mysql

###########################################################################################
# Despliegue de la aplicación web
###########################################################################################

cd /tmp

# Clonamos el repositorio de la aplicación
rm -rf /tmp/iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Importamos el script de base de datos
mysql -u root -p$MYSQL_ROOT_PASSWORD < /tmp/iaw-practica-lamp/db/database.sql

# Eliminamos el directorio del repositorio
rm -rf /tmp/iaw-practica-lamp