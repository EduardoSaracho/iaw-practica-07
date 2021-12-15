# Práctica 7: Balanceador de carga con Nginx

#### Nombre y Apellidos: Eduardo Saracho Cruz
#### Curso: 2º ASIR - Implantación de aplicaciones web
#### IES Celia Viñas 2021-2022
---
## Paso 1
<p style='text-align: justify;'>Configuramos las variables que vamos a utilizar a lo largo del script para que visualmente sea más sencillo.</p>

```bash
#!/bin/bash
set -x

##########################################################################
# Variables de configuracion
##########################################################################

IP_FRONTEND_01=172.31.22.13
IP_FRONTEND_02=172.31.28.43
EMAIL_HTTPS=demo@demo.es
DOMAIN=practica7iaw.ddns.net
```
---
## Paso 2
<p style='text-align: justify;'>Antes de comenzar cualquier instalación, es recomendable actualizar el sistema para evitar posibles errores.</p>

```bash
##########################################################################
# Actualizamos el sistema
##########################################################################

apt update -y
apt upgrade -y
```
---
## Paso 3
<p style='text-align: justify;'>Instalamos el <b>servidor web Nginx</b> y copiamos nuestro fichero <b>default_loadbalancer</b> en el directorio <i>/etc/nginx/sites-available/default</i> y reemplazamos el texto del archivo con la IP privada de nuestro <b>frontend1</b> y <b>frontend2</b>. Seguidamente reiniciamos Nginx para que se apliquen los cambios.</p>

```bash
##########################################################################
# Instalación y configuración del servidor Nginx
##########################################################################

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
##########################################################################
# Configuración HTTPS
##########################################################################

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