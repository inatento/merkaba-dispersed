#!/bin/bash
. ../config.sh

if [ -z $SUDO_USER ]
then
    dash "error" "Este script necesita ejecutarse con sudo"
    error "Debes estar en el directorio '/setup'"
    error "Usa: sudo -E ./fabric_setup.sh"
    exit 0
fi

install_fabric() {
    ACTUAL_PWD=$PWD
    cd $HOME
    FABRIC_BINS=$HOME/fabric-samples/bin

    dash "info" "Instalación de las herramientas de Fabric CLI" 

    # Install prerequisites
    additional "Descarga de paquetes"
    execute_with_spinner "curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh && chmod +x install-fabric.sh"
    execute_with_spinner "./install-fabric.sh docker samples binary"

    # Check if it's OK
    export PATH="$PATH:$FABRIC_BINS"
    if command -v peer &> /dev/null; then
        success "Los binarios de Fabric se han instalado correctamente"
    else
        error "ERROR: Los binarios de Fabric no se pudieron agregar correctamente al PATH"
        exit 1
    fi
    cd $ACTUAL_PWD
}

install_fabric

dash "warning" "Listo, sal de la terminal e ingresa nuevamente para ver reflejados los cambios"
highlight "Después, para confirmar ejecuta:"
highlight "peer version"