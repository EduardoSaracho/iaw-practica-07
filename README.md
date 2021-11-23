# Práctica 6 y 7: LEMP Stack y Balanceador de carga con Nginx

#### Nombre y Apellidos: Eduardo Saracho Cruz
#### Curso: 2º ASIR - Implantación de aplicaciones web
#### IES Celia Viñas 2021-2022
---
## **Frontend con socket UNIX**
---
## Paso 1
<p style='text-align: justify;'>Configuramos las variables que vamos a utilizar a lo largo del script para que visualmente sea más sencillo.</p>

```bash
#!/bin/bash
set -x

##################################################################################
# Variables de configuracion
##################################################################################

# Configuramos la IP privada de la máquina de MySQL
IP_MYSQL=172.31.22.213
```
---
## Paso 2
<p style='text-align: justify;'>Antes de comenzar cualquier instalación, es recomendable actualizar el sistema para evitar posibles errores.</p>

```bash
#################################################################################
# Actualizamos el sistema
#################################################################################

apt update -y
apt upgrade -y
```
## Paso 3
<p style='text-align: justify;'>Instalamos la <b>pila LEMP</b>, la cual consta de el <b>servidor web Nginx</b> y <b>PHP</b>. Instalaremos además, el paquete <b>FastCGI Process Manager</b> para <b>PHP</b> y el paquete que permite conectar <b>PHP</b> con <b>MySQL</b>. Adicionalmente debemos de copiar el archivo <b>default_socket_unix</b> a la ruta <i>/etc/nginx/sites-available/default</i> y configurar <b>PHP FPM</b> para trabajar con socket TCP.</p>

```bash
##################################################################################
# Instalación de la pila LEMP (Solución 1: Socket UNIX en la misma máquina)
##################################################################################

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
```
---
## Paso 4
<p style='text-align: justify;'>Iniciamos el despliegue de la aplicación web clonando el repositorio de la aplicación y moviendo el código fuente al directorio <i>/var/www/html</i>. Hecho lo anterior, configuramos la dirección ip de <b>MySQL</b> en el archivo de configuración. Eliminaremos el archivo <b>index.html</b> y el directorio del repositorio <i>/var/www/html/iaw-practica-lamp</i> para evitar problemas de seguridad y cambiaremos el propietario, seguido del grupo de los archivos.</p>

```bash
##################################################################################
# Despliegue de la aplicación web
##################################################################################

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
```
---
## **Frontend con socket TCP**
---
## Paso 1
<p style='text-align: justify;'>Configuramos las variables que vamos a utilizar a lo largo del script para que visualmente sea más sencillo.</p>

```bash
#!/bin/bash
set -x

##################################################################################
# Variables de configuracion
##################################################################################

# Configuramos la IP privada de la máquina de MySQL
IP_MYSQL=172.31.22.213
```
---
## Paso 2
<p style='text-align: justify;'>Antes de comenzar cualquier instalación, es recomendable actualizar el sistema para evitar posibles errores.</p>

```bash
#################################################################################
# Actualizamos el sistema
#################################################################################

apt update -y
apt upgrade -y
```
## Paso 3
<p style='text-align: justify;'>Instalamos la <b>pila LEMP</b>, la cual consta de el <b>servidor web Nginx</b> y <b>PHP</b>. Instalaremos además, el paquete <b>FastCGI Process Manager</b> para <b>PHP</b> y el paquete que permite conectar <b>PHP</b> con <b>MySQL</b>. Adicionalmente debemos de copiar el archivo <b>default_socket_tcp</b> a la ruta <i>/etc/nginx/sites-available/default</i> y configurar <b>PHP FPM</b> para trabajar con socket TCP.</p>

```bash
##################################################################################
# Instalación de la pila LEMP (Solución 2: Socket TCP en la misma máquina)
##################################################################################

# Instalamos el servidor web Nginx
apt install nginx -y

# Instalamos el paquete de PHP FastCGI Process Manager
apt install php-fpm -y

# Instalamos el paquete para conectar con MySQL
apt install php-mysql -y

# Copiamos el archivo de configuración de Nginx
cp conf/default_socket_tcp /etc/nginx/sites-available/default

# Configuramos PHP FPM para trabajar con un socket TCP
sed -i "s#/run/php/php7.4-fpm.sock#127.0.0.1:9000#" /etc/php/7.4/fpm/pool.d/www.conf

# Reiniciamos el servicio de PHP FPM
systemctl restart php7.4-fpm

# Reiniciamos el servidor web Nginx
systemctl restart nginx
```
---
## Paso 4
<p style='text-align: justify;'>Iniciamos el despliegue de la aplicación web clonando el repositorio de la aplicación y moviendo el código fuente al directorio <i>/var/www/html</i>. Hecho lo anterior, configuramos la dirección ip de <b>MySQL</b> en el archivo de configuración. Eliminaremos el archivo <b>index.html</b> y el directorio del repositorio <i>/var/www/html/iaw-practica-lamp</i> para evitar problemas de seguridad y cambiaremos el propietario, seguido del grupo de los archivos.</p>

```bash
##################################################################################
# Despliegue de la aplicación web
##################################################################################

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
```
---
## **Backend**
---
## Paso 1
<p style='text-align: justify;'>Configuramos las variables que vamos a utilizar a lo largo del script para que visualmente sea más sencillo.</p>

```bash
#!/bin/bash
set -x

#################################################################################
# Variables de configuracion
#################################################################################

MYSQL_ROOT_PASSWORD=root
```
---
## Paso 2
<p style='text-align: justify;'>Antes de comenzar cualquier instalación, es recomendable actualizar el sistema para evitar posibles errores.</p>

```bash
#################################################################################
# Actualizamos el sistema
#################################################################################

apt update -y
apt upgrade -y
```
---
## Paso 3
<p style='text-align: justify;'>Instalamos <b>MySQL Server</b>, cambiamos la contraseña del usuario root y configuramos <b>MySQL</b> para aceptar conexiones desde cualquier interfaz de red.</p>

```bash
##################################################################################
# Instalación de la pila LAMP
##################################################################################

# Instalamos MySQL Server
apt install mysql-server -y

# Cambiamos la contraseña del usuario root
mysql <<< "ALTER USER root@'localhost' IDENTIFIED WITH caching_sha2_password BY '$MYSQL_ROOT_PASSWORD';"

# Configuramos MySQL para aceptar conexiones desde cualquier interfaz de red
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Reiniciamos el servicio de MySQL
systemctl restart mysql
```
---
## Paso 4
<p style='text-align: justify;'>Iniciamos el despliegue de la aplicación web clonando el repositorio de la aplicación. Hecho lo anterior, importamos el script de base de datos y eliminamos el directorio del repositorio.</p>

```bash
##################################################################################
# Despliegue de la aplicación web
##################################################################################

cd /tmp

# Clonamos el repositorio de la aplicación
rm -rf /tmp/iaw-practica-lamp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git

# Importamos el script de base de datos
mysql -u root -p$MYSQL_ROOT_PASSWORD < /tmp/iaw-practica-lamp/db/database.sql

# Eliminamos el directorio del repositorio
rm -rf /tmp/iaw-practica-lamp
```
---
## **Balanceador de carga**
---
## Paso 1
<p style='text-align: justify;'>Configuramos las variables que vamos a utilizar a lo largo del script para que visualmente sea más sencillo.</p>

```bash
#!/bin/bash
set -x

##################################################################################
# Variables de configuracion
##################################################################################

IP_FRONTEND_01=172.31.22.13
IP_FRONTEND_02=172.31.28.43
EMAIL_HTTPS=demo@demo.es
DOMAIN=practica7iaw.ddns.net
```
---
## Paso 2
<p style='text-align: justify;'>Antes de comenzar cualquier instalación, es recomendable actualizar el sistema para evitar posibles errores.</p>

```bash
#################################################################################
# Actualizamos el sistema
#################################################################################

apt update -y
apt upgrade -y
```
---
## Paso 3
<p style='text-align: justify;'>Instalamos el <b>servidor web Nginx</b> y copiamos nuestro fichero <b>default_loadbalancer</b> en el directorio <i>/etc/nginx/sites-available/default</i> y reemplazamos el texto del archivo con la IP privada de nuestro <b>frontend1</b> y <b>frontend2</b>. Seguidamente reiniciamos Nginx para que se apliquen los cambios.</p>

```bash
##################################################################################
# Instalación y configuración del servidor Nginx
##################################################################################

# Instalamos el servidor web Nginx
apt install nginx -y

# Copiamos el archivo de configuración de Nginx
cp conf/default_loadbalancer  /etc/nginx/sites-available/default

# Reemplazamos el texto del archivo 000-default.conf
sed -i "s/IP_FRONTEND_01/$IP_FRONTEND_01/" /etc/nginx/sites-available/default
sed -i "s/IP_FRONTEND_02/$IP_FRONTEND_02/" /etc/nginx/sites-available/default

# Reiniciamos el servicio de Nginx
sudo systemctl restart nginx
```
---
## Paso 4
<p style='text-align: justify;'>Para finalizar, debemos de configurar <b>HTTPS</b>. Instalaremos <b>snapd</b> y el <b>cliente de Certbot con el módulo de nginx</b>. Solicitaremos el certificado <b>HTTPS</b> sin necesidad de interactuar con su asistente, ejecutando el código con las respuestas correspondientes.</p>

```bash
##################################################################################
# Configuración HTTPS
##################################################################################

# Realizamos la instalación de snapd
snap install core
snap refresh core

# Eliminamos instalaciones previas de certbot con apt
apt-get remove certbot

# Instalamos el cliente certbot y su complemento de Nginx con snap
snap install certbot python3-certbot-nginx

# Solicitamos el certificado HTTPS
certbot --nginx -m $EMAIL_HTTPS --agree-tos --no-eff-email -d $DOMAIN
```