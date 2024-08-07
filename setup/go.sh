#!/bin/bash
. ../config.sh

if [ -z $SUDO_USER ]
then
    dash "error" "Este script necesita ejecutarse con sudo"
    error "Debes estar en el directorio '/setup'"
    error "Usa: sudo ./go.sh"
    exit 0
fi

install_go (){
    dash "info" "Instalación de go 1.21.0"
    additional "Limpiar posibles paquetes residuales"
    execute_with_spinner "apt update && apt upgrade -y"
    execute_with_spinner "apt remove golang-go"
    execute_with_spinner "apt purge golang-go"
    execute_with_spinner "rm -rf /usr/local/go"

    additional "Descargar e instalar Go 1.21"
    execute_with_spinner "wget https://golang.org/dl/go1.21.0.linux-amd64.tar.gz"
    execute_with_spinner "tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz"
    rm go1.21.0.linux-amd64.tar.gz
}

install_go

# Configurar PATH
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.profile
source ~/.profile
echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc 
source ~/.bashrc

dash "warning" "Listo, sal de la terminal e ingresa nuevamente para ver reflejados los cambios"
highlight "Después, para confirmar ejecuta:"
highlight "go version"