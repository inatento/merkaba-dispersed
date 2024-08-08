#!/bin/bash

#Cargar configuracion de scripts
. ../config.sh

# Define el contenido JSON para la memoria de los contenedores
json_content='{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}'

if [ -z $SUDO_USER ]
then
    dash "error" "Este script necesita ejecutarse con sudo"
    error "Debes estar en el directorio '/setup'"
    error "Usa: sudo ./docker.sh"
    exit 0
fi


install_docker() {
    dash "info" "Instalación de Docker"
    execute_with_spinner "apt-get update"
    execute_with_spinner "apt-get install -y apt-transport-https ca-certificates curl software-properties-common"
    execute_with_spinner "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -"
    execute_with_spinner "apt-key fingerprint 0EBFCD88"
    execute_with_spinner 'add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"'
    execute_with_spinner "apt-get update"
    execute_with_spinner 'apt-get install -y "docker-ce"'
    execute_with_spinner "docker info"
    additional "Agregando $SUDO_USER al grupo 'docker'"
    execute_with_spinner "usermod -aG docker $SUDO_USER"
    # Escribir json_content en /etc/docker/daemon.json
    echo "$json_content" | sudo tee /etc/docker/daemon.json > /dev/null
    additional "Configuración de espacio de memoria para los logs de Docker:"
    cat /etc/docker/daemon.json
    execute_with_spinner "chmod 666 /var/run/docker.sock"
}



# Instalar docker
install_docker


additional "Reiniciando servicio de docker..."
execute_with_spinner "service docker restart"
execute_with_spinner "systemctl daemon-reload"
execute_with_spinner "systemctl restart docker"

# Installing docker compose
./compose.sh

dash "warning" "Listo, sal de la terminal e ingresa nuevamente para ver reflejados los cambios"
highlight "Después, para confirmar ejecuta:"
highlight "docker info"
highlight "docker-compose version"
