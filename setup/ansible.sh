#!/bin/bash
. ../config.sh

if [ -z $SUDO_USER ]
then
    dash "error" "Este script necesita ejecutarse con sudo"
    error "Debes estar en el directorio '/setup'"
    error "Usa: sudo ./ansible.sh"
    exit 0
fi

install_ansible (){
    dash "info" "Instalación de Ansible"
    execute_with_spinner "apt update"
    execute_with_spinner "apt install software-properties-common"
    execute_with_spinner "add-apt-repository --yes --update ppa:ansible/ansible"
    execute_with_spinner "apt install ansible -y"
    execute_with_spinner "ansible-config init --disabled -t all > ansible.cfg"
}

install_ansible

if command ansible --version &> /dev/null; then
    success "Ansible ha sido instalado"
else
    error "ERROR: No se pudo completar la instalación de Ansible"
    exit 1
fi