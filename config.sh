# config.sh

# Definir colores
RED='\e[0;31m'
GREEN='\e[0;32m'
YELLOW='\e[0;33m'
BLUE='\e[0;34m'
MAGENTA='\e[0;35m'
CYAN='\e[0;36m'
WHITE='\e[0;37m'
NC='\e[0m' # Sin color

# Funciones para imprimir mensajes con colores
error() {
  echo -e "${RED}$1${NC}"
}

success() {
  echo -e "${GREEN}$1${NC}"
}

warning() {
  echo -e "${YELLOW}$1${NC}"
}

info() {
  echo -e "${BLUE}$1${NC}"
}

highlight() {
  echo -e "${MAGENTA}$1${NC}"
}

additional() {
  echo -e "${CYAN}$1${NC}"
}

# Función para resaltar texto en marquesina y aplicar color
dash() {
    local type=$1
    local message=$2
    local length=${#message}
    local border=$(printf '#%.0s' $(seq 1 $((length + 8))))

    echo "$border"
    echo "### $message ###"
    echo "$border"

    case $type in
        info)
            info "$message"
            ;;
        success)
            success "$message"
            ;;
        warning)
            warning "$message"
            ;;
        error)
            error "$message"
            ;;
        highlight)
            highlight "$message"
            ;;
        additional)
            additional "$message"
            ;;
        *)
            echo "$message"
            ;;
    esac
}


# Función para resaltar texto en marquesina y aplicar color
dash() {
    local type=$1
    local message=$2
    local term_width=$(tput cols)
    local message_length=${#message}
    local border_length=$((term_width - 2))
    local padding_length=$(( (border_length - message_length) / 2 ))

    case $type in
        info)
            color=$BLUE
            ;;
        success)
            color=$GREEN
            ;;
        warning)
            color=$YELLOW
            ;;
        error)
            color=$RED
            ;;
        highlight)
            color=$MAGENTA
            ;;
        additional)
            color=$CYAN
            ;;
        *)
            color=$WHITE
            ;;
    esac

    local border=$(printf '#%.0s' $(seq 1 $term_width))
    local padding=$(printf ' %.0s' $(seq 1 $padding_length))

    echo -e "${color}${border}${NC}"
    echo -e "${color}#${padding}${message}${padding}#${NC}"
    echo -e "${color}${border}${NC}"
}

#!/bin/bash

# Definir colores
RED='\e[0;31m'
GREEN='\e[0;32m'
NC='\e[0m' # Sin color

# Función para mostrar el spinner
show_spinner() {
  local pid=$1
  local delay=0.1
  local spinstr='|/-\'

  echo -ne "${CYAN}"
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  echo -ne "${NC}"
}

# Función para ejecutar comandos con el spinner y mensajes coloreados
execute_with_spinner() {
  local cmd="$1"
  info "Ejecutando: $cmd"

  bash -c "$cmd" &
  local cmd_pid=$!

  show_spinner $cmd_pid

  wait $cmd_pid
  local exit_code=$?

  if [ $exit_code -eq 0 ]; then
    success "SUCCESS: Comando ejecutado con éxito."
  else
    error "ERROR: Comando falló $exit_code."
  fi

  return $exit_code
}