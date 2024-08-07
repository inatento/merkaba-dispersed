#!/bin/bash
. ../config.sh

if [ -z $SUDO_USER ]
then
    dash "error" "Este script necesita ejecutarse con sudo"
    error "Debes estar en el directorio '/setup'"
    error "Usa: sudo ./jq.sh"
    exit 0
fi

# Installs the JQ Utility
dash "info" "Instalación de jq"
execute_with_spinner "sudo apt-get install -y jq"