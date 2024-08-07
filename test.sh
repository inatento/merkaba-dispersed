#!/bin/bash

# Incluir el archivo de configuración de colores
source config.sh
# o
# . config.sh

# Uso de las funciones de colores
info "Este es un mensaje de información."
success "La operación se completó con éxito."
warning "Esta es una advertencia."
error "Ocurrió un error."
highlight "Información destacada."
additional "Información adicional."

dash "info" "Este es un mensaje de información en marquesina."
dash "success" "Este es un mensaje de éxito en marquesina."
dash "warning" "Este es un mensaje de advertencia en marquesina."
dash "error" "Este es un mensaje de error en marquesina."
dash "highlight" "Este es un mensaje destacado en marquesina."
dash "additional" "Este es un mensaje adicional en marquesina."
echo -e "${WHITE}Este es un mensaje neutro.${NC}"

execute_with_spinner "apt-get update"