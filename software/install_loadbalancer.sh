#!/bin/bash
set -x

#####################################################################################
# Variables de configuracion
#####################################################################################

IP_FRONTEND_01=172.31.22.13
IP_FRONTEND_02=172.31.28.43
EMAIL_HTTPS=demo@demo.es
DOMAIN=practica7iaw.ddns.net

#####################################################################################
# Actualizamos el sistema
#####################################################################################

apt update -y
apt upgrade -y

#####################################################################################
# Instalación y configuración del servidor Nginx
#####################################################################################

# Instalamos el servidor web Nginx
apt install nginx -y

# Copiamos el archivo de configuración de Nginx
cp conf/default_loadbalancer  /etc/nginx/sites-available/default

# Reemplazamos el texto del archivo 000-default.conf
sed -i "s/IP_FRONTEND_01/$IP_FRONTEND_01/" /etc/nginx/sites-available/default
sed -i "s/IP_FRONTEND_02/$IP_FRONTEND_02/" /etc/nginx/sites-available/default
sed -i "s/DOMAIN/$DOMAIN/" /etc/nginx/sites-available/default

# Reiniciamos el servicio de Nginx
sudo systemctl restart nginx

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